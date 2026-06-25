-- CreateTable
CREATE TABLE IF NOT EXISTS "user" (
    "id" SERIAL PRIMARY KEY,
    "username" TEXT NOT NULL,
    "hashed_password" TEXT NOT NULL,
    "nickname" TEXT NOT NULL DEFAULT '',
    "avatar" TEXT NOT NULL DEFAULT '',
    "email" TEXT NOT NULL DEFAULT '',
    "bio" TEXT NOT NULL DEFAULT '',
    "is_admin" BOOLEAN NOT NULL DEFAULT false,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- CreateTable
CREATE TABLE IF NOT EXISTS "Category" (
    "id" SERIAL PRIMARY KEY,
    "name" TEXT NOT NULL,
    "slug" TEXT NOT NULL,
    "description" TEXT NOT NULL DEFAULT '',
    "sort" INTEGER NOT NULL DEFAULT 0,
    "post_count" INTEGER NOT NULL DEFAULT 0,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- CreateTable
CREATE TABLE IF NOT EXISTS "Tag" (
    "id" SERIAL PRIMARY KEY,
    "name" TEXT NOT NULL,
    "slug" TEXT NOT NULL,
    "post_count" INTEGER NOT NULL DEFAULT 0
);

-- CreateTable
CREATE TABLE IF NOT EXISTS "Post" (
    "id" SERIAL PRIMARY KEY,
    "title" TEXT NOT NULL,
    "slug" TEXT NOT NULL,
    "description" TEXT NOT NULL DEFAULT '',
    "content" TEXT NOT NULL DEFAULT '',
    "cover" TEXT NOT NULL DEFAULT '',
    "category_id" INTEGER,
    "status" TEXT NOT NULL DEFAULT 'draft',
    "is_pinned" BOOLEAN NOT NULL DEFAULT false,
    "views" INTEGER NOT NULL DEFAULT 0,
    "likes" INTEGER NOT NULL DEFAULT 0,
    "word_count" INTEGER NOT NULL DEFAULT 0,
    "reading_time" INTEGER NOT NULL DEFAULT 0,
    "published_at" TIMESTAMP(3),
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT "Post_category_id_fkey" FOREIGN KEY ("category_id") REFERENCES "Category" ("id") ON DELETE SET NULL ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE IF NOT EXISTS "PostTag" (
    "post_id" INTEGER NOT NULL,
    "tag_id" INTEGER NOT NULL,
    PRIMARY KEY ("post_id", "tag_id"),
    CONSTRAINT "PostTag_post_id_fkey" FOREIGN KEY ("post_id") REFERENCES "Post" ("id") ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT "PostTag_tag_id_fkey" FOREIGN KEY ("tag_id") REFERENCES "Tag" ("id") ON DELETE CASCADE ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE IF NOT EXISTS "GitHubUser" (
    "id" SERIAL PRIMARY KEY,
    "github_id" INTEGER NOT NULL,
    "login" TEXT NOT NULL,
    "avatar" TEXT NOT NULL DEFAULT '',
    "bio" TEXT NOT NULL DEFAULT '',
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- CreateTable
CREATE TABLE IF NOT EXISTS "Comment" (
    "id" SERIAL PRIMARY KEY,
    "post_id" INTEGER NOT NULL,
    "parent_id" INTEGER,
    "github_user_id" INTEGER,
    "email_user_name" TEXT NOT NULL DEFAULT '',
    "email_user_avatar" TEXT NOT NULL DEFAULT '',
    "content" TEXT NOT NULL,
    "likes" INTEGER NOT NULL DEFAULT 0,
    "ip" TEXT NOT NULL DEFAULT '',
    "status" TEXT NOT NULL DEFAULT 'approved',
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT "Comment_post_id_fkey" FOREIGN KEY ("post_id") REFERENCES "Post" ("id") ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT "Comment_parent_id_fkey" FOREIGN KEY ("parent_id") REFERENCES "Comment" ("id") ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT "Comment_github_user_id_fkey" FOREIGN KEY ("github_user_id") REFERENCES "GitHubUser" ("id") ON DELETE SET NULL ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE IF NOT EXISTS "Message" (
    "id" SERIAL PRIMARY KEY,
    "github_user_id" INTEGER,
    "parent_id" INTEGER,
    "content" TEXT NOT NULL,
    "ip" TEXT NOT NULL DEFAULT '',
    "status" TEXT NOT NULL DEFAULT 'approved',
    "likes" INTEGER NOT NULL DEFAULT 0,
    "email_user_name" TEXT NOT NULL DEFAULT '',
    "email_user_avatar" TEXT NOT NULL DEFAULT '',
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT "Message_parent_id_fkey" FOREIGN KEY ("parent_id") REFERENCES "Message" ("id") ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT "Message_github_user_id_fkey" FOREIGN KEY ("github_user_id") REFERENCES "GitHubUser" ("id") ON DELETE SET NULL ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE IF NOT EXISTS "Chatter" (
    "id" SERIAL PRIMARY KEY,
    "content" TEXT NOT NULL,
    "images" TEXT NOT NULL DEFAULT '[]',
    "mood" TEXT NOT NULL DEFAULT '',
    "likes" INTEGER NOT NULL DEFAULT 0,
    "comments_count" INTEGER NOT NULL DEFAULT 0,
    "status" TEXT NOT NULL DEFAULT 'draft',
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- CreateTable
CREATE TABLE IF NOT EXISTS "ChatterComment" (
    "id" SERIAL PRIMARY KEY,
    "chatter_id" INTEGER NOT NULL,
    "parent_id" INTEGER,
    "github_user_id" INTEGER,
    "email_user_name" TEXT NOT NULL DEFAULT '',
    "email_user_avatar" TEXT NOT NULL DEFAULT '',
    "content" TEXT NOT NULL,
    "ip" TEXT NOT NULL DEFAULT '',
    "likes" INTEGER NOT NULL DEFAULT 0,
    "status" TEXT NOT NULL DEFAULT 'approved',
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT "ChatterComment_chatter_id_fkey" FOREIGN KEY ("chatter_id") REFERENCES "Chatter" ("id") ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT "ChatterComment_parent_id_fkey" FOREIGN KEY ("parent_id") REFERENCES "ChatterComment" ("id") ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT "ChatterComment_github_user_id_fkey" FOREIGN KEY ("github_user_id") REFERENCES "GitHubUser" ("id") ON DELETE SET NULL ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE IF NOT EXISTS "Album" (
    "id" SERIAL PRIMARY KEY,
    "title" TEXT NOT NULL,
    "description" TEXT NOT NULL DEFAULT '',
    "cover" TEXT NOT NULL DEFAULT '',
    "photo_count" INTEGER NOT NULL DEFAULT 0,
    "sort" INTEGER NOT NULL DEFAULT 0,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- CreateTable
CREATE TABLE IF NOT EXISTS "Photo" (
    "id" SERIAL PRIMARY KEY,
    "album_id" INTEGER NOT NULL,
    "url" TEXT NOT NULL,
    "caption" TEXT NOT NULL DEFAULT '',
    "orientation" TEXT NOT NULL DEFAULT 'landscape',
    "sort" INTEGER NOT NULL DEFAULT 0,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT "Photo_album_id_fkey" FOREIGN KEY ("album_id") REFERENCES "Album" ("id") ON DELETE CASCADE ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE IF NOT EXISTS "Project" (
    "id" SERIAL PRIMARY KEY,
    "name" TEXT NOT NULL,
    "slug" TEXT NOT NULL,
    "description" TEXT NOT NULL DEFAULT '',
    "long_description" TEXT NOT NULL DEFAULT '',
    "cover_image" TEXT NOT NULL DEFAULT '',
    "tech_stack" TEXT NOT NULL DEFAULT '[]',
    "link_github" TEXT NOT NULL DEFAULT '',
    "link_gitee" TEXT NOT NULL DEFAULT '',
    "link_live" TEXT NOT NULL DEFAULT '',
    "link_docs" TEXT NOT NULL DEFAULT '',
    "status" TEXT NOT NULL DEFAULT 'developing',
    "status_label" TEXT NOT NULL DEFAULT '',
    "is_featured" BOOLEAN NOT NULL DEFAULT false,
    "sort" INTEGER NOT NULL DEFAULT 0,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- CreateTable
CREATE TABLE IF NOT EXISTS "FriendLink" (
    "id" SERIAL PRIMARY KEY,
    "name" TEXT NOT NULL,
    "url" TEXT NOT NULL,
    "avatar" TEXT NOT NULL DEFAULT '',
    "description" TEXT NOT NULL DEFAULT '',
    "sort" INTEGER NOT NULL DEFAULT 0,
    "is_approved" BOOLEAN NOT NULL DEFAULT false,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- CreateTable
CREATE TABLE IF NOT EXISTS "BookmarkCategory" (
    "id" SERIAL PRIMARY KEY,
    "name" TEXT NOT NULL,
    "icon" TEXT NOT NULL DEFAULT '',
    "description" TEXT NOT NULL DEFAULT '',
    "sort" INTEGER NOT NULL DEFAULT 0,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- CreateTable
CREATE TABLE IF NOT EXISTS "BookmarkSite" (
    "id" SERIAL PRIMARY KEY,
    "category_id" INTEGER NOT NULL,
    "name" TEXT NOT NULL,
    "url" TEXT NOT NULL,
    "icon" TEXT NOT NULL DEFAULT '',
    "description" TEXT NOT NULL DEFAULT '',
    "platforms" TEXT NOT NULL DEFAULT '[]',
    "sort" INTEGER NOT NULL DEFAULT 0,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT "BookmarkSite_category_id_fkey" FOREIGN KEY ("category_id") REFERENCES "BookmarkCategory" ("id") ON DELETE CASCADE ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE IF NOT EXISTS "Music" (
    "id" SERIAL PRIMARY KEY,
    "title" TEXT NOT NULL,
    "artist" TEXT NOT NULL DEFAULT '',
    "cover" TEXT NOT NULL DEFAULT '',
    "src" TEXT NOT NULL,
    "lrc" TEXT NOT NULL DEFAULT '',
    "lrcSrc" TEXT NOT NULL DEFAULT '',
    "type" TEXT NOT NULL DEFAULT 'local',
    "sort" INTEGER NOT NULL DEFAULT 0,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- CreateTable
CREATE TABLE IF NOT EXISTS "SiteConfig" (
    "id" SERIAL PRIMARY KEY,
    "key" TEXT NOT NULL,
    "value" TEXT NOT NULL DEFAULT '',
    "description" TEXT NOT NULL DEFAULT '',
    "updated_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- CreateTable
CREATE TABLE IF NOT EXISTS "Visitor" (
    "id" SERIAL PRIMARY KEY,
    "ip" TEXT NOT NULL,
    "path" TEXT NOT NULL DEFAULT '',
    "user_agent" TEXT NOT NULL DEFAULT '',
    "city" TEXT NOT NULL DEFAULT '',
    "region" TEXT NOT NULL DEFAULT '',
    "country" TEXT NOT NULL DEFAULT '',
    "district" TEXT NOT NULL DEFAULT '',
    "org" TEXT NOT NULL DEFAULT '',
    "asn" TEXT NOT NULL DEFAULT '',
    "is_mobile" BOOLEAN NOT NULL DEFAULT false,
    "is_proxy" BOOLEAN NOT NULL DEFAULT false,
    "is_hosting" BOOLEAN NOT NULL DEFAULT false,
    "browser" TEXT NOT NULL DEFAULT '',
    "os" TEXT NOT NULL DEFAULT '',
    "device_type" TEXT NOT NULL DEFAULT '',
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- CreateTable
CREATE TABLE IF NOT EXISTS "login_log" (
    "id" SERIAL PRIMARY KEY,
    "user_id" INTEGER NOT NULL DEFAULT 0,
    "username" TEXT NOT NULL DEFAULT '',
    "ip" TEXT NOT NULL DEFAULT '',
    "address" TEXT NOT NULL DEFAULT '',
    "system" TEXT NOT NULL DEFAULT '',
    "browser" TEXT NOT NULL DEFAULT '',
    "summary" TEXT NOT NULL DEFAULT '',
    "operating_time" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- CreateTable
CREATE TABLE IF NOT EXISTS "book_category" (
    "id" SERIAL PRIMARY KEY,
    "name" TEXT NOT NULL,
    "slug" TEXT NOT NULL,
    "description" TEXT NOT NULL DEFAULT '',
    "sort" INTEGER NOT NULL DEFAULT 0,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- CreateTable
CREATE TABLE IF NOT EXISTS "book" (
    "id" SERIAL PRIMARY KEY,
    "title" TEXT NOT NULL,
    "author" TEXT NOT NULL DEFAULT '',
    "cover" TEXT NOT NULL DEFAULT '',
    "description" TEXT NOT NULL DEFAULT '',
    "file_url" TEXT NOT NULL,
    "format" TEXT NOT NULL DEFAULT 'epub',
    "file_size" INTEGER NOT NULL DEFAULT 0,
    "category_id" INTEGER,
    "sort" INTEGER NOT NULL DEFAULT 0,
    "views" INTEGER NOT NULL DEFAULT 0,
    "chapter_count" INTEGER NOT NULL DEFAULT 0,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT "book_category_id_fkey" FOREIGN KEY ("category_id") REFERENCES "book_category" ("id") ON DELETE SET NULL ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE IF NOT EXISTS "book_chapter" (
    "id" SERIAL PRIMARY KEY,
    "book_id" INTEGER NOT NULL,
    "title" TEXT NOT NULL,
    "href" TEXT NOT NULL,
    "order" INTEGER NOT NULL DEFAULT 0,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT "book_chapter_book_id_fkey" FOREIGN KEY ("book_id") REFERENCES "book" ("id") ON DELETE CASCADE ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE IF NOT EXISTS "reading_progress" (
    "id" SERIAL PRIMARY KEY,
    "book_id" INTEGER NOT NULL,
    "chapter_id" INTEGER,
    "chapter_title" TEXT NOT NULL DEFAULT '',
    "position" REAL NOT NULL DEFAULT 0,
    "updated_at" TIMESTAMP(3) NOT NULL,
    CONSTRAINT "reading_progress_book_id_fkey" FOREIGN KEY ("book_id") REFERENCES "book" ("id") ON DELETE CASCADE ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE IF NOT EXISTS "book_note" (
    "id" SERIAL PRIMARY KEY,
    "book_id" INTEGER NOT NULL,
    "chapter_id" INTEGER,
    "text" TEXT NOT NULL,
    "note" TEXT NOT NULL DEFAULT '',
    "color" TEXT NOT NULL DEFAULT '#facc15',
    "cfi" TEXT NOT NULL DEFAULT '',
    "chapter_title" TEXT NOT NULL DEFAULT '',
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT "book_note_book_id_fkey" FOREIGN KEY ("book_id") REFERENCES "book" ("id") ON DELETE CASCADE ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE IF NOT EXISTS "email_verification" (
    "id" SERIAL PRIMARY KEY,
    "email" TEXT NOT NULL,
    "code" TEXT NOT NULL,
    "verified" BOOLEAN NOT NULL DEFAULT false,
    "expires_at" TIMESTAMP(3) NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- CreateIndex: 唯一索引
CREATE UNIQUE INDEX IF NOT EXISTS "user_username_key" ON "user"("username");
CREATE UNIQUE INDEX IF NOT EXISTS "Category_name_key" ON "Category"("name");
CREATE UNIQUE INDEX IF NOT EXISTS "Category_slug_key" ON "Category"("slug");
CREATE UNIQUE INDEX IF NOT EXISTS "Tag_name_key" ON "Tag"("name");
CREATE UNIQUE INDEX IF NOT EXISTS "Tag_slug_key" ON "Tag"("slug");
CREATE UNIQUE INDEX IF NOT EXISTS "Post_slug_key" ON "Post"("slug");
CREATE UNIQUE INDEX IF NOT EXISTS "GitHubUser_github_id_key" ON "GitHubUser"("github_id");
CREATE UNIQUE INDEX IF NOT EXISTS "Project_slug_key" ON "Project"("slug");
CREATE UNIQUE INDEX IF NOT EXISTS "SiteConfig_key_key" ON "SiteConfig"("key");
CREATE UNIQUE INDEX IF NOT EXISTS "book_category_name_key" ON "book_category"("name");
CREATE UNIQUE INDEX IF NOT EXISTS "book_category_slug_key" ON "book_category"("slug");
CREATE UNIQUE INDEX IF NOT EXISTS "reading_progress_book_id_key" ON "reading_progress"("book_id");

-- CreateIndex: 普通索引
CREATE INDEX IF NOT EXISTS "Post_slug_idx" ON "Post"("slug");
CREATE INDEX IF NOT EXISTS "Post_status_idx" ON "Post"("status");
CREATE INDEX IF NOT EXISTS "Post_category_id_idx" ON "Post"("category_id");
CREATE INDEX IF NOT EXISTS "Comment_post_id_idx" ON "Comment"("post_id");
CREATE INDEX IF NOT EXISTS "Comment_status_idx" ON "Comment"("status");
CREATE INDEX IF NOT EXISTS "Comment_github_user_id_idx" ON "Comment"("github_user_id");
CREATE INDEX IF NOT EXISTS "Message_status_idx" ON "Message"("status");
CREATE INDEX IF NOT EXISTS "Message_parent_id_idx" ON "Message"("parent_id");
CREATE INDEX IF NOT EXISTS "Message_github_user_id_idx" ON "Message"("github_user_id");
CREATE INDEX IF NOT EXISTS "Chatter_status_idx" ON "Chatter"("status");
CREATE INDEX IF NOT EXISTS "ChatterComment_chatter_id_idx" ON "ChatterComment"("chatter_id");
CREATE INDEX IF NOT EXISTS "ChatterComment_status_idx" ON "ChatterComment"("status");
CREATE INDEX IF NOT EXISTS "ChatterComment_github_user_id_idx" ON "ChatterComment"("github_user_id");
CREATE INDEX IF NOT EXISTS "Photo_album_id_idx" ON "Photo"("album_id");
CREATE INDEX IF NOT EXISTS "BookmarkSite_category_id_idx" ON "BookmarkSite"("category_id");
CREATE INDEX IF NOT EXISTS "Music_type_idx" ON "Music"("type");
CREATE INDEX IF NOT EXISTS "Music_sort_idx" ON "Music"("sort");
CREATE INDEX IF NOT EXISTS "Visitor_ip_idx" ON "Visitor"("ip");
CREATE INDEX IF NOT EXISTS "Visitor_created_at_idx" ON "Visitor"("created_at");
CREATE INDEX IF NOT EXISTS "login_log_user_id_idx" ON "login_log"("user_id");
CREATE INDEX IF NOT EXISTS "login_log_operating_time_idx" ON "login_log"("operating_time");
CREATE INDEX IF NOT EXISTS "book_category_id_idx" ON "book"("category_id");
CREATE INDEX IF NOT EXISTS "book_format_idx" ON "book"("format");
CREATE INDEX IF NOT EXISTS "book_chapter_book_id_idx" ON "book_chapter"("book_id");
CREATE INDEX IF NOT EXISTS "book_chapter_order_idx" ON "book_chapter"("order");
CREATE INDEX IF NOT EXISTS "book_note_book_id_idx" ON "book_note"("book_id");
CREATE INDEX IF NOT EXISTS "email_verification_email_idx" ON "email_verification"("email");
CREATE INDEX IF NOT EXISTS "email_verification_code_idx" ON "email_verification"("code");

-- SeedData: 默认管理员账户（用户名: admin，密码: admin123）
-- 首次登录后请立即在后台修改密码！
-- 已存在则跳过，可安全重复执行
INSERT INTO "user" ("username", "hashed_password", "nickname", "is_admin", "created_at", "updated_at")
VALUES ('admin', '$2b$10$mL5.rtwJCuWteWAvDLxnOuNHSN9W3oA7epS0.fZ2SvM6ve4pCpMEa', '管理员', true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
ON CONFLICT ("username") DO NOTHING;

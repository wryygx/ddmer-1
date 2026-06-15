import { PrismaClient } from "@prisma/client";
import bcrypt from "bcryptjs";

const prisma = new PrismaClient();

async function main() {
  // 创建 admin 用户
  const adminPassword = await bcrypt.hash("admin123", 10);
  await prisma.user.upsert({
    where: { username: "admin" },
    update: { nickname: "Ddmer" },
    create: {
      username: "admin",
      hashed_password: adminPassword,
      nickname: "Ddmer",
      is_admin: true,
    },
  });

  // 创建 ddmer 用户
  const ddmerPassword = await bcrypt.hash("skmbm123", 10);
  await prisma.user.upsert({
    where: { username: "ddmer" },
    update: {},
    create: {
      username: "ddmer",
      hashed_password: ddmerPassword,
      nickname: "ddmer",
      is_admin: true,
    },
  });

  console.log("Seed completed: admin and ddmer users created.");
}

main()
  .then(async () => {
    await prisma.$disconnect();
  })
  .catch(async (e) => {
    console.error(e);
    await prisma.$disconnect();
    process.exit(1);
  });
-- CreateEnum
CREATE TYPE "Roles" AS ENUM ('ADMIN', 'USER');

-- CreateEnum
CREATE TYPE "ServiceStatus" AS ENUM ('BUDGETED', 'IN_PROGRESS', 'COMPLETED', 'LATE', 'INVOICED');

-- CreateEnum
CREATE TYPE "PaymentMethod" AS ENUM ('CREDIT_CARD', 'PIX', 'BOLETO', 'TRANSFER');

-- CreateEnum
CREATE TYPE "Currency" AS ENUM ('USD', 'BRL', 'EUR');

-- CreateTable
CREATE TABLE "users" (
    "id" TEXT NOT NULL,
    "first_name" TEXT NOT NULL,
    "last_name" TEXT NOT NULL,
    "role" "Roles" NOT NULL DEFAULT 'USER',
    "email" TEXT NOT NULL,
    "password_hash" TEXT NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "users_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "user_settings" (
    "id" TEXT NOT NULL,
    "user_id" TEXT NOT NULL,
    "pix_key" TEXT,
    "currency" "Currency" NOT NULL DEFAULT 'BRL',
    "darkMode" BOOLEAN NOT NULL DEFAULT false,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "user_settings_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "costumers" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "company" TEXT,
    "provider_id" TEXT NOT NULL,
    "email" TEXT,
    "phone" TEXT,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "costumers_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "services" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "description" TEXT NOT NULL,
    "provider_id" TEXT NOT NULL,
    "terms" TEXT,
    "price" DECIMAL(65,30) NOT NULL DEFAULT 0,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "services_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "services_billing" (
    "id" TEXT NOT NULL,
    "costumer_id" TEXT NOT NULL,
    "provider_id" TEXT NOT NULL,
    "service_id" TEXT NOT NULL,
    "price" DECIMAL(65,30) NOT NULL,
    "dueDate" TIMESTAMP(3) NOT NULL,
    "service_status" "ServiceStatus" NOT NULL DEFAULT 'BUDGETED',
    "paymentMethod" "PaymentMethod" DEFAULT 'PIX',
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "services_billing_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "users_email_key" ON "users"("email");

-- CreateIndex
CREATE INDEX "users_email_idx" ON "users"("email");

-- CreateIndex
CREATE UNIQUE INDEX "user_settings_user_id_key" ON "user_settings"("user_id");

-- CreateIndex
CREATE INDEX "services_billing_costumer_id_service_status_idx" ON "services_billing"("costumer_id", "service_status");

-- AddForeignKey
ALTER TABLE "user_settings" ADD CONSTRAINT "user_settings_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "costumers" ADD CONSTRAINT "costumers_provider_id_fkey" FOREIGN KEY ("provider_id") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "services" ADD CONSTRAINT "services_provider_id_fkey" FOREIGN KEY ("provider_id") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "services_billing" ADD CONSTRAINT "services_billing_service_id_fkey" FOREIGN KEY ("service_id") REFERENCES "services"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "services_billing" ADD CONSTRAINT "services_billing_costumer_id_fkey" FOREIGN KEY ("costumer_id") REFERENCES "costumers"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "services_billing" ADD CONSTRAINT "services_billing_provider_id_fkey" FOREIGN KEY ("provider_id") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

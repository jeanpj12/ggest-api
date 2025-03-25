import { BadRequestException, Injectable } from '@nestjs/common';
import { CreateAuthDto } from './dto/create-auth.dto';
import { PrismaService } from 'src/prisma/prisma.service';
import { compare, hash } from 'bcrypt';
import { JwtService } from '@nestjs/jwt';
import { SignInDto } from './dto/sign-in.dto';

@Injectable()
export class AuthService {
  constructor(
    private prismaService: PrismaService,
    private jwtService: JwtService,
  ) {}

  async signUp({ email, firstName, lastName, password }: CreateAuthDto) {
    const userSameEmail = await this.prismaService.user.findUnique({
      where: { email },
    });

    if (userSameEmail) {
      throw new BadRequestException('This email is already registered');
    }

    const passwordHash = await hash(password, 8);

    await this.prismaService.user.create({
      data: {
        firstName,
        lastName,
        email,
        passwordHash,
      },
    });

    return { message: 'User created successfully', email };
  }

  async signIn({
    email,
    password,
  }: SignInDto): Promise<{ access_token: string }> {
    const user = await this.prismaService.user.findUnique({ where: { email } });

    if (!user) {
      throw new BadRequestException('Incorrect Email or Password');
    }

    const passwordCheck = await compare(password, user.passwordHash);

    if (!passwordCheck) {
      throw new BadRequestException('Incorrect Email or Password');
    }

    const payload = { sub: user.id };

    return {
      access_token: await this.jwtService.signAsync(payload),
    };
  }
}

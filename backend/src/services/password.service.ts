import bcrypt from 'bcrypt';

const SALT_ROUNDS = 12;
const PASSWORD_REGEX = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[^\w\s]).{8,}$/;

export class PasswordService {
  static validate(password: string): boolean {
    return PASSWORD_REGEX.test(password);
  }

  static async hashPassword(password: string): Promise<string> {
    if (!this.validate(password)) {
      throw new Error('Password does not meet strength requirements');
    }
    return bcrypt.hash(password, SALT_ROUNDS);
  }

  static async comparePassword(password: string, hash: string): Promise<boolean> {
    return bcrypt.compare(password, hash);
  }
}

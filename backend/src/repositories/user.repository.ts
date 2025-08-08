import { db } from '../database/connection';

export interface User {
  id: string;
  email: string;
  password_hash: string;
  first_name: string;
  last_name: string;
  role: 'parent' | 'child';
  language: string;
  created_at?: Date;
  updated_at?: Date;
}

export type CreateUserDTO = Omit<User, 'created_at' | 'updated_at'>;
export type UpdateUserDTO = Partial<Omit<CreateUserDTO, 'id'>>;

export class UserRepository {
  async create(userData: CreateUserDTO): Promise<User> {
    const [user] = await db<User>('users')
      .insert(userData)
      .returning(['id', 'email', 'password_hash', 'first_name', 'last_name', 'role', 'language', 'created_at', 'updated_at']);
    return user;
  }

  async findByEmail(email: string): Promise<User | null> {
    const user = await db<User>('users').where({ email }).first();
    return user || null;
  }

  async findById(id: string): Promise<User | null> {
    const user = await db<User>('users').where({ id }).first();
    return user || null;
  }

  async update(id: string, data: UpdateUserDTO): Promise<User> {
    const [user] = await db<User>('users')
      .where({ id })
      .update(data)
      .returning(['id', 'email', 'password_hash', 'first_name', 'last_name', 'role', 'language', 'created_at', 'updated_at']);
    return user;
  }

  async delete(id: string): Promise<void> {
    await db<User>('users').where({ id }).del();
  }
}

export const userRepository = new UserRepository();

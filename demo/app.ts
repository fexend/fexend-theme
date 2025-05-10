// TypeScript Test File

// Interface definitions
interface User {
  id: number;
  name: string;
  email: string;
  active: boolean;
  role: UserRole;
  createdAt: Date;
}

enum UserRole {
  Admin = "admin",
  Editor = "editor",
  Viewer = "viewer",
}

// Example class with typed properties and methods
class UserService {
  private users: User[] = [];

  constructor(initialUsers: User[] = []) {
    this.users = initialUsers;
  }

  public getUser(id: number): User | undefined {
    return this.users.find((user) => user.id === id);
  }

  public addUser(user: Omit<User, "id">): User {
    const newUser: User = {
      ...user,
      id: this.generateId(),
    };

    this.users.push(newUser);
    return newUser;
  }

  public updateUser(id: number, userData: Partial<User>): User | undefined {
    const index = this.users.findIndex((user) => user.id === id);

    if (index !== -1) {
      this.users[index] = { ...this.users[index], ...userData };
      return this.users[index];
    }

    return undefined;
  }

  private generateId(): number {
    return Math.max(0, ...this.users.map((u) => u.id)) + 1;
  }
}

// Generic type example
function createState<T>(initial: T): [() => T, (value: T) => void] {
  let state: T = initial;

  const getState = () => state;
  const setState = (value: T) => {
    state = value;
  };

  return [getState, setState];
}

// Usage example
const testUser: User = {
  id: 1,
  name: "John Doe",
  email: "john@example.com",
  active: true,
  role: UserRole.Editor,
  createdAt: new Date(),
};

const userService = new UserService([testUser]);
console.log(userService.getUser(1));

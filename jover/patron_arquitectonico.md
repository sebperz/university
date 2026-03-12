# Patrones Arquitectónicos

Los patrones arquitectónicos son soluciones probadas a problemas recurrentes en el diseño de software a nivel de arquitectura. A diferencia de los patrones de diseño (más granulares), los patrones arquitectónicos definen la estructura general del sistema.

---

## 1. MVC (Modelo-Vista-Controlador)

### Definición

MVC es un patrón arquitectónico que separa una aplicación en tres componentes principales: **Modelo** (datos y lógica de negocio), **Vista** (interfaz de usuario) y **Controlador** (intermediario que maneja las interacciones).

### Estructura

```
                    ┌─────────────┐
                    │   Usuario   │
                    └──────┬──────┘
                           │ Interactúa
                           ▼
                    ┌─────────────┐
                    │ Controlador │  ← Recibe input, coordina
                    └──────┬──────┘
                           │
              ┌────────────┴────────────┐
              ▼                         ▼
       ┌─────────────┐          ┌─────────────┐
       │   Modelo    │          │    Vista    │
       │  (Datos,    │          │   (UI,      │
       │  Lógica)    │◀────────▶│  Presentación)
       └─────────────┘  Actualiza └─────────────┘
```

### Ejemplo en TypeScript

```typescript
// ==================== MODELO ====================

interface User {
  id: string;
  name: string;
  email: string;
  createdAt: Date;
}

interface Task {
  id: string;
  title: string;
  completed: boolean;
  userId: string;
}

// Repositorio (acceso a datos)
class UserRepository {
  private users: Map<string, User> = new Map();

  findById(id: string): User | undefined {
    return this.users.get(id);
  }

  findAll(): User[] {
    return Array.from(this.users.values());
  }

  save(user: User): void {
    this.users.set(user.id, user);
  }

  delete(id: string): void {
    this.users.delete(id);
  }
}

class TaskRepository {
  private tasks: Map<string, Task> = new Map();

  findByUserId(userId: string): Task[] {
    return Array.from(this.tasks.values()).filter(t => t.userId === userId);
  }

  save(task: Task): void {
    this.tasks.set(task.id, task);
  }

  delete(id: string): void {
    this.tasks.delete(id);
  }

  toggleComplete(id: string): Task | undefined {
    const task = this.tasks.get(id);
    if (task) {
      task.completed = !task.completed;
    }
    return task;
  }
}

// ==================== CONTROLADOR ====================

class UserController {
  constructor(private userRepo: UserRepository) {}

  getAll(): User[] {
    return this.userRepo.findAll();
  }

  getById(id: string): User | undefined {
    return this.userRepo.findById(id);
  }

  create(name: string, email: string): User {
    const user: User = {
      id: crypto.randomUUID(),
      name,
      email,
      createdAt: new Date()
    };
    this.userRepo.save(user);
    return user;
  }

  update(id: string, name: string, email: string): User | undefined {
    const user = this.userRepo.findById(id);
    if (user) {
      user.name = name;
      user.email = email;
      this.userRepo.save(user);
    }
    return user;
  }

  delete(id: string): boolean {
    const exists = this.userRepo.findById(id);
    if (exists) {
      this.userRepo.delete(id);
      return true;
    }
    return false;
  }
}

class TaskController {
  constructor(private taskRepo: TaskRepository) {}

  getUserTasks(userId: string): Task[] {
    return this.taskRepo.findByUserId(userId);
  }

  createTask(userId: string, title: string): Task {
    const task: Task = {
      id: crypto.randomUUID(),
      title,
      completed: false,
      userId
    };
    this.taskRepo.save(task);
    return task;
  }

  toggleTask(id: string): Task | undefined {
    return this.taskRepo.toggleComplete(id);
  }

  deleteTask(id: string): boolean {
    const task = this.taskRepo.findById(id);
    if (task) {
      this.taskRepo.delete(id);
      return true;
    }
    return false;
  }
}

// ==================== VISTA ====================

// Vista de consola (puede ser HTML/React/Vue)
class ConsoleUserView {
  renderUsers(users: User[]): void {
    console.log('\n=== Lista de Usuarios ===');
    users.forEach(user => {
      console.log(`[${user.id.slice(0,8)}] ${user.name} - ${user.email}`);
    });
  }

  renderUser(user: User | undefined): void {
    if (user) {
      console.log(`\nUsuario: ${user.name}`);
      console.log(`Email: ${user.email}`);
      console.log(`ID: ${user.id}`);
      console.log(`Creado: ${user.createdAt}`);
    } else {
      console.log('\nUsuario no encontrado');
    }
  }

  renderMessage(message: string): void {
    console.log(`\n>>> ${message}`);
  }
}

class ConsoleTaskView {
  renderTasks(tasks: Task[]): void {
    console.log('\n=== Lista de Tareas ===');
    tasks.forEach(task => {
      const status = task.completed ? '[✓]' : '[ ]';
      console.log(`${status} ${task.title}`);
    });
  }

  renderTask(task: Task | undefined): void {
    if (task) {
      console.log(`\nTarea: ${task.title}`);
      console.log(`Estado: ${task.completed ? 'Completada' : 'Pendiente'}`);
    }
  }
}

// ==================== APLICACIÓN ====================

class Application {
  private userController: UserController;
  private taskController: TaskController;
  private userView: ConsoleUserView;
  private taskView: ConsoleTaskView;

  constructor() {
    const userRepo = new UserRepository();
    const taskRepo = new TaskRepository();
    
    this.userController = new UserController(userRepo);
    this.taskController = new TaskController(taskRepo);
    this.userView = new ConsoleUserView();
    this.taskView = new ConsoleTaskView();
  }

  run(): void {
    // Crear usuarios
    const user1 = this.userController.create('Alice', 'alice@example.com');
    const user2 = this.userController.create('Bob', 'bob@example.com');
    
    // Crear tareas
    this.taskController.createTask(user1.id, 'Aprender TypeScript');
    this.taskController.createTask(user1.id, 'Hacer ejercicio');
    this.taskController.createTask(user2.id, 'Leer un libro');
    
    // Mostrar vista
    this.userView.renderUsers(this.userController.getAll());
    this.taskView.renderTasks(this.taskController.getUserTasks(user1.id));
    
    // Actualizar
    this.taskController.toggleTask(
      this.taskController.getUserTasks(user1.id)[0].id
    );
    
    this.taskView.renderTasks(this.taskController.getUserTasks(user1.id));
  }
}

// Versión con Express (web)
import express from 'express';

class ExpressUserController {
  constructor(private userController: UserController) {}

  getRoutes(): express.Router {
    const router = express.Router();

    router.get('/users', (req, res) => {
      const users = this.userController.getAll();
      res.json(users);
    });

    router.get('/users/:id', (req, res) => {
      const user = this.userController.getById(req.params.id);
      if (!user) return res.status(404).json({ error: 'Not found' });
      res.json(user);
    });

    router.post('/users', (req, res) => {
      const { name, email } = req.body;
      const user = this.userController.create(name, email);
      res.status(201).json(user);
    });

    router.put('/users/:id', (req, res) => {
      const { name, email } = req.body;
      const user = this.userController.update(req.params.id, name, email);
      if (!user) return res.status(404).json({ error: 'Not found' });
      res.json(user);
    });

    router.delete('/users/:id', (req, res) => {
      const deleted = this.userController.delete(req.params.id);
      if (!deleted) return res.status(404).json({ error: 'Not found' });
      res.status(204).send();
    });

    return router;
  }
}

// Uso
// new Application().run();
```

### Cuándo Usarlo

- Aplicaciones web tradicionales
- Frameworks que lo implementan nativamente (Rails, Django, Spring MVC)
- Proyectos donde la separación UI/negocio es clara

### Ventajas

- Separación clara de responsabilidades
- Fácil de entender para principiantes
- Soporte nativo en muchos frameworks
- Testing independiente de componentes

### Desventajas

- Puede generar controladores obesity
- Acoplamiento implícito Vista-Controlador
- Dificultad para escalar en aplicaciones complejas

---

## 2. MVVM (Modelo-Vista-ViewModel)

### Definición

MVVM es una evolución de MVC diseñada principalmente para aplicaciones con interfaces de usuario reactivas (como WPF, Xamarin, Vue.js, Angular). Introduce el **ViewModel** como un intermediario que maneja la lógica de presentación y mantiene el estado de la vista.

### Estructura

```
┌─────────────────────────────────────────────────────┐
│                      VISTA                          │
│   (Componentes UI, Data Binding, Eventos)          │
└──────────────────────┬──────────────────────────────┘
                       │ Data Binding
                       ▼
┌─────────────────────────────────────────────────────┐
│                   VIEWMODEL                         │
│   (Estado de UI, Comandos, Lógica de presentación)│
└──────────────────────┬──────────────────────────────┘
                       │
        ┌──────────────┴──────────────┐
        ▼                               ▼
┌─────────────────┐          ┌─────────────────┐
│     MODELO      │          │     MODELO      │
│   (Datos,       │          │   (Datos de     │
│    Entidades)   │          │    Entidades)   │
└─────────────────┘          └─────────────────┘
```

### Ejemplo en TypeScript (Vue.js style)

```typescript
// ==================== MODELO ====================

interface User {
  id: string;
  name: string;
  email: string;
  avatar?: string;
}

interface Post {
  id: string;
  userId: string;
  title: string;
  body: string;
  likes: number;
}

// Repositorio
class UserRepository {
  private users: User[] = [
    { id: '1', name: 'Alice', email: 'alice@example.com', avatar: '👩' },
    { id: '2', name: 'Bob', email: 'bob@example.com', avatar: '👨' }
  ];

  async findAll(): Promise<User[]> {
    return Promise.resolve(this.users);
  }

  async findById(id: string): Promise<User | undefined> {
    return Promise.resolve(this.users.find(u => u.id === id));
  }
}

class PostRepository {
  private posts: Post[] = [
    { id: '1', userId: '1', title: 'Hola mundo', body: 'Mi primer post', likes: 5 },
    { id: '2', userId: '2', title: 'TypeScript', body: 'Es genial', likes: 10 }
  ];

  async findByUserId(userId: string): Promise<Post[]> {
    return Promise.resolve(this.posts.filter(p => p.userId === userId));
  }

  async like(postId: string): Promise<Post | undefined> {
    const post = this.posts.find(p => p.id === postId);
    if (post) post.likes++;
    return Promise.resolve(post);
  }
}

// ==================== VIEWMODEL ====================

// Interface reactive
type Listener<T> = (value: T) => void;

class Reactive<T> {
  private listeners: Listener<T>[] = [];

  constructor(private value: T) {}

  get(): T {
    return this.value;
  }

  set(value: T): void {
    this.value = value;
    this.notify();
  }

  subscribe(listener: Listener<T>): () => void {
    this.listeners.push(listener);
    return () => {
      this.listeners = this.listeners.filter(l => l !== listener);
    };
  }

  private notify(): void {
    this.listeners.forEach(l => l(this.value));
  }
}

// ViewModel para lista de usuarios
class UserListViewModel {
  users: Reactive<User[]> = new Reactive([]);
  loading: Reactive<boolean> = new Reactive(false);
  error: Reactive<string | null> = new Reactive(null);
  selectedUser: Reactive<User | null> = new Reactive(null);

  private userRepo: UserRepository;

  constructor(userRepo: UserRepository) {
    this.userRepo = userRepo;
  }

  async loadUsers(): Promise<void> {
    this.loading.set(true);
    this.error.set(null);

    try {
      const users = await this.userRepo.findAll();
      this.users.set(users);
    } catch (e) {
      this.error.set((e as Error).message);
    } finally {
      this.loading.set(false);
    }
  }

  selectUser(user: User | null): void {
    this.selectedUser.set(user);
  }

  getUserDisplayName(user: User): string {
    return `${user.avatar || ''} ${user.name}`;
  }
}

// ViewModel para detalle de usuario y sus posts
class UserDetailViewModel {
  user: Reactive<User | null> = new Reactive(null);
  posts: Reactive<Post[]> = new Reactive([]);
  loading: Reactive<boolean> = new Reactive(false);

  private userRepo: UserRepository;
  private postRepo: PostRepository;

  constructor(userRepo: UserRepository, postRepo: PostRepository) {
    this.userRepo = userRepo;
    this.postRepo = postRepo;
  }

  async loadUserWithPosts(userId: string): Promise<void> {
    this.loading.set(true);

    try {
      const [user, posts] = await Promise.all([
        this.userRepo.findById(userId),
        this.postRepo.findByUserId(userId)
      ]);

      this.user.set(user || null);
      this.posts.set(posts);
    } finally {
      this.loading.set(false);
    }
  }

  async likePost(postId: string): Promise<void> {
    await this.postRepo.like(postId);
    const currentPosts = this.posts.get();
    const updatedPost = currentPosts.find(p => p.id === postId);
    if (updatedPost) {
      this.posts.set([...currentPosts]);
    }
  }

  get totalLikes(): number {
    return this.posts.get().reduce((sum, p) => sum + p.likes, 0);
  }
}

// ==================== VISTA (Componentes UI) ====================

// Componente de lista de usuarios
class UserListView {
  private cleanup: (() => void)[] = [];

  constructor(private viewModel: UserListViewModel) {
    this.setupBindings();
  }

  private setupBindings(): void {
    this.cleanup.push(
      this.viewModel.users.subscribe(users => this.renderUserList(users))
    );
    this.cleanup.push(
      this.viewModel.loading.subscribe(loading => this.renderLoading(loading))
    );
    this.cleanup.push(
      this.viewModel.error.subscribe(error => this.renderError(error))
    );
  }

  private renderUserList(users: User[]): void {
    console.log('\n=== Lista de Usuarios ===');
    users.forEach(user => {
      const displayName = this.viewModel.getUserDisplayName(user);
      console.log(`  ${displayName} - ${user.email}`);
    });
  }

  private renderLoading(loading: boolean): void {
    console.log(loading ? '⏳ Cargando...' : '');
  }

  private renderError(error: string | null): void {
    if (error) console.log(`❌ Error: ${error}`);
  }

  onSelectUser(user: User): void {
    this.viewModel.selectUser(user);
  }

  destroy(): void {
    this.cleanup.forEach(fn => fn());
  }
}

// ==================== APLICACIÓN ====================

class App {
  async main(): Promise<void> {
    const userRepo = new UserRepository();
    const postRepo = new PostRepository();

    const userListVM = new UserListViewModel(userRepo);
    const userDetailVM = new UserDetailViewModel(userRepo, postRepo);

    const userListView = new UserListView(userListVM);

    await userListVM.loadUsers();

    const firstUser = userListVM.users.get()[0];
    if (firstUser) {
      await userDetailVM.loadUserWithPosts(firstUser.id);
      console.log(`\nPosts de ${firstUser.name}:`);
      userDetailVM.posts.get().forEach(post => {
        console.log(`  - ${post.title} (${post.likes} likes)`);
      });
      console.log(`Total likes: ${userDetailVM.totalLikes}`);
    }
  }
}
```

### Cuándo Usarlo

- Aplicaciones de una sola página (SPA)
- Desarrollo con frameworks reactivos (Vue, Angular, React)
- Aplicaciones con UI compleja y estado rico

### Ventajas

- Data binding automático
- Testeo del ViewModel sin UI
- Separación clara de lógica de presentación
- Facilita el desarrollo paralelo UI/negocio

### Desventajas

- Overhead para aplicaciones simples
- Curva de aprendizaje de binding
- Puede generar complejidad en estados

---

## 3. API Gateway

### Definición

El API Gateway es un servidor que actúa como punto único de entrada para un conjunto de microservicios. Maneja requests de clientes, autentica, enruta a los servicios apropiados, y puede implementar cross-cutting concerns como logging, rate limiting, y caching.

### Estructura

```
                    ┌──────────────────┐
                    │   Cliente Móvil  │
                    │   Cliente Web    │
                    │   Cliente API    │
                    └────────┬─────────┘
                             │
                             ▼
                 ┌────────────────────┐
                 │    API Gateway     │
                 │  ┌──────────────┐  │
                 │  │ Routing      │  │
                 │  │ Auth         │  │
                 │  │ Rate Limit   │  │
                 │  │ Cache        │  │
                 │  │ Logging      │  │
                 │  │ Transform    │  │
                 │  └──────────────┘  │
                 └────────┬────────────┘
                          │
        ┌─────────────────┼─────────────────┐
        │                 │                 │
        ▼                 ▼                 ▼
┌───────────────┐ ┌───────────────┐ ┌───────────────┐
│  Users        │ │  Orders       │ │  Products     │
│  Service      │ │  Service      │ │  Service      │
│  (Puerto 3001)│ │  (Puerto 3002)│ │  (Puerto 3003)│
└───────────────┘ └───────────────┘ └───────────────┘
```

### Ejemplo en TypeScript

```typescript
import express, { Request, Response, NextFunction } from 'express';

interface ServiceConfig {
  name: string;
  url: string;
  routes: RouteConfig[];
}

interface RouteConfig {
  path: string;
  method: string;
  targetService: string;
  authRequired?: boolean;
  rateLimit?: number;
}

interface MiddlewareConfig {
  rateLimit: { windowMs: number; max: number };
  timeout: number;
  retryAttempts: number;
}

class APIGateway {
  private app: express.Application;
  private services: Map<string, ServiceConfig> = new Map();
  private rateLimitStore: Map<string, { count: number; resetTime: number }> = new Map();

  constructor(private config: MiddlewareConfig) {
    this.app = express();
    this.setupMiddleware();
  }

  registerService(config: ServiceConfig): void {
    this.services.set(config.name, config);
    console.log(`Registered service: ${config.name} at ${config.url}`);
  }

  private setupMiddleware(): void {
    this.app.use(express.json());
    this.app.use(this.authMiddleware.bind(this));
    this.app.use(this.rateLimitMiddleware.bind(this));
    this.app.use(this.proxyMiddleware.bind(this));
    this.app.use(this.errorHandler.bind(this));
  }

  private authMiddleware(req: Request, res: Response, next: NextFunction): void {
    const token = req.headers.authorization?.replace('Bearer ', '');
    
    if (token) {
      (req as any).user = { id: 'user-123', token };
    }
    next();
  }

  private rateLimitMiddleware(req: Request, res: Response, next: NextFunction): void {
    const clientId = (req as any).user?.id || req.ip;
    const now = Date.now();
    const key = `${clientId}:${req.path}`;
    
    const record = this.rateLimitStore.get(key);
    
    if (!record || now > record.resetTime) {
      this.rateLimitStore.set(key, {
        count: 1,
        resetTime: now + this.config.rateLimit.windowMs
      });
      return next();
    }

    if (record.count >= this.config.rateLimit.max) {
      return res.status(429).json({
        error: 'Too many requests',
        retryAfter: Math.ceil((record.resetTime - now) / 1000)
      });
    }

    record.count++;
    next();
  }

  private async proxyMiddleware(req: Request, res: Response): Promise<void> {
    const serviceConfig = this.findMatchingRoute(req.path, req.method);
    
    if (!serviceConfig) {
      res.status(404).json({ error: 'Route not found' });
      return;
    }

    try {
      const targetUrl = `${serviceConfig.url}${req.path}`;
      const response = await this.makeRequest({
        method: req.method,
        url: targetUrl,
        body: req.body,
        headers: {
          ...req.headers,
          'x-user-id': (req as any).user?.id || ''
        }
      });

      res.status(response.status).json(response.body);
    } catch (error) {
      res.status(502).json({ error: 'Service unavailable' });
    }
  }

  private async makeRequest(config: {
    method: string;
    url: string;
    body?: any;
    headers?: Record<string, string>;
  }): Promise<{ status: number; body: any }> {
    console.log(`[Gateway] ${config.method} ${config.url}`);
    return { status: 200, body: { message: 'Proxied response' } };
  }

  private findMatchingRoute(path: string, method: string): ServiceConfig | undefined {
    for (const service of this.services.values()) {
      const route = service.routes.find(
        r => path.match(new RegExp(r.path.replace('*', '.*'))) && 
             r.method.toUpperCase() === method.toUpperCase()
      );
      if (route) return service;
    }
    return undefined;
  }

  private errorHandler(err: Error, req: Request, res: Response, next: NextFunction): void {
    console.error('[Gateway Error]', err.message);
    res.status(500).json({ error: 'Internal gateway error' });
  }

  start(port: number): void {
    this.app.listen(port, () => {
      console.log(`API Gateway running on port ${port}`);
    });
  }
}

const gateway = new APIGateway({
  rateLimit: { windowMs: 60000, max: 100 },
  timeout: 5000,
  retryAttempts: 3
});

gateway.registerService({
  name: 'users',
  url: 'http://localhost:3001',
  routes: [
    { path: '/api/users/*', method: 'GET', targetService: 'users' },
    { path: '/api/users', method: 'POST', targetService: 'users' }
  ]
});

gateway.registerService({
  name: 'orders',
  url: 'http://localhost:3002',
  routes: [
    { path: '/api/orders/*', method: 'GET', targetService: 'orders' },
    { path: '/api/orders', method: 'POST', targetService: 'orders' }
  ]
});

gateway.start(8080);
```

### Cuándo Usarlo

- Arquitectura de microservicios
- Aplicaciones móviles que consumen múltiples APIs
- Cuando necesitas una API unificada para múltiples clientes

### Ventajas

- Punto único de entrada
- Desacoplamiento clientes-servicios
- Centralización de cross-cutting concerns
- Seguridad y monitoreo centralizado

### Desventajas

- Punto único de fallo
- Latencia adicional
- Complejidad en configuración

---

## 4. Load Balancer

### Definición

El Load Balancer es un componente que distribuye el tráfico de red o aplicación entre múltiples servidores. Mejora la disponibilidad, redundancia y rendimiento de las aplicaciones.

### Estructura

```
                    ┌──────────────────┐
                    │   Load Balancer  │
                    │  ┌────────────┐  │
                    │  │  Strategy  │  │
                    │  │ Round Robin│  │
                    │  │ Least Conn │  │
                    │  │ IP Hash    │  │
                    │  │ Weighted   │  │
                    │  └────────────┘  │
                    └────────┬─────────┘
                             │
        ┌────────────────────┼────────────────────┐
        │                    │                    │
        ▼                    ▼                    ▼
┌───────────────┐    ┌───────────────┐    ┌───────────────┐
│   Server 1    │    │   Server 2    │    │   Server 3    │
│  (Port 3001)  │    │  (Port 3002)  │    │  (Port 3003)  │
│  Health: OK   │    │  Health: OK   │    │  Health: OK   │
└───────────────┘    └───────────────┘    └───────────────┘
```

### Ejemplo en TypeScript

```typescript
interface Server {
  id: string;
  host: string;
  port: number;
  weight: number;
  currentConnections: number;
  isHealthy: boolean;
  lastHealthCheck: Date;
}

interface LoadBalancerConfig {
  strategy: 'round-robin' | 'least-connections' | 'ip-hash' | 'weighted';
}

interface LoadBalancingStrategy {
  selectServer(servers: Server[]): Server | null;
}

class RoundRobinStrategy implements LoadBalancingStrategy {
  private currentIndex = 0;

  selectServer(servers: Server[]): Server | null {
    const healthyServers = servers.filter(s => s.isHealthy);
    if (healthyServers.length === 0) return null;

    const server = healthyServers[this.currentIndex % healthyServers.length];
    this.currentIndex++;
    return server;
  }
}

class LeastConnectionsStrategy implements LoadBalancingStrategy {
  selectServer(servers: Server[]): Server | null {
    const healthyServers = servers.filter(s => s.isHealthy);
    if (healthyServers.length === 0) return null;

    return healthyServers.reduce((min, server) =>
      server.currentConnections < min.currentConnections ? server : min
    );
  }
}

class WeightedStrategy implements LoadBalancingStrategy {
  selectServer(servers: Server[]): Server | null {
    const healthyServers = servers.filter(s => s.isHealthy);
    if (healthyServers.length === 0) return null;

    const totalWeight = healthyServers.reduce((sum, s) => sum + s.weight, 0);
    let random = Math.random() * totalWeight;

    for (const server of healthyServers) {
      random -= server.weight;
      if (random <= 0) return server;
    }

    return healthyServers[healthyServers.length - 1];
  }
}

class LoadBalancer {
  private servers: Map<string, Server> = new Map();
  private strategy: LoadBalancingStrategy;

  constructor(private config: LoadBalancerConfig) {
    this.strategy = this.createStrategy();
  }

  private createStrategy(): LoadBalancingStrategy {
    switch (this.config.strategy) {
      case 'round-robin': return new RoundRobinStrategy();
      case 'least-connections': return new LeastConnectionsStrategy();
      case 'weighted': return new WeightedStrategy();
      default: return new RoundRobinStrategy();
    }
  }

  addServer(id: string, host: string, port: number, weight: number = 1): void {
    this.servers.set(id, {
      id, host, port, weight,
      currentConnections: 0,
      isHealthy: true,
      lastHealthCheck: new Date()
    });
    console.log(`[LB] Added server ${id} (${host}:${port})`);
  }

  getServer(): Server | null {
    const server = this.strategy.selectServer(Array.from(this.servers.values()));
    if (server) {
      server.currentConnections++;
    }
    return server;
  }

  releaseServer(server: Server): void {
    server.currentConnections = Math.max(0, server.currentConnections - 1);
  }

  getStats(): void {
    console.log('\n=== Load Balancer Stats ===');
    for (const server of this.servers.values()) {
      console.log(`${server.id}: ${server.isHealthy ? 'HEALTHY' : 'UNHEALTHY'} | ` +
        `Connections: ${server.currentConnections} | Weight: ${server.weight}`);
    }
  }
}

const lb = new LoadBalancer({ strategy: 'weighted' });

lb.addServer('server-1', 'localhost', 3001, 2);
lb.addServer('server-2', 'localhost', 3002, 1);
lb.addServer('server-3', 'localhost', 3003, 1);

for (let i = 0; i < 5; i++) {
  const server = lb.getServer();
  console.log(`Request ${i + 1} -> Server: ${server?.id}`);
  if (server) lb.releaseServer(server);
}

lb.getStats();
```

### Cuándo Usarlo

- Aplicaciones de alta disponibilidad
- Arquitecturas de microservicios
- Cuando se necesita escalar horizontalmente

### Ventajas

- Alta disponibilidad
- Escalabilidad horizontal
- Balanceo de recursos
- Failover automático

### Desventajas

- Punto único de fallo (si no hay redundancia)
- Complejidad adicional
- Latencia de red

---

## 5. CQRS (Command Query Responsibility Segregation)

### Definición

CQRS es un patrón que separa las operaciones de lectura (queries) de las operaciones de escritura (commands). Esto permite optimizar cada tipo de operación independientemente y usar modelos de datos diferentes.

### Estructura

```
┌─────────────────────────────────────────────────────────────────┐
│                         CLIENTE                                 │
└─────────────────────────────┬───────────────────────────────────┘
                              │
         ┌────────────────────┼────────────────────┐
         ▼                                        ▼
┌─────────────────────┐              ┌─────────────────────┐
│      COMMANDS      │              │       QUERIES       │
│  (Escritura)       │              │    (Lectura)        │
│  ┌─────────────┐   │              │  ┌─────────────┐    │
│  │ Create      │   │              │  │ Get User    │    │
│  │ Update      │   │              │  │ List Orders │    │
│  │ Delete      │   │              │  │ Get Stats   │    │
│  └──────┬──────┘   │              │  └──────┬──────┘    │
└─────────┼───────────┘              └─────────┼───────────┘
          │                                    │
          ▼                                    ▼
┌─────────────────────┐              ┌─────────────────────┐
│   COMMAND MODEL     │              │    QUERY MODEL      │
│  (Write Database)   │              │   (Read Database)   │
│  - PostgreSQL       │              │  - MongoDB          │
│  - Validaciones     │              │  - Elasticsearch    │
└─────────┬───────────┘              └─────────┬───────────┘
          │                                    │
          └──────────────┬─────────────────────┘
                         ▼
              ┌─────────────────────┐
              │   EVENT BUS         │
              │ (Sincronización)    │
              └─────────────────────┘
```

### Ejemplo en TypeScript

```typescript
interface User {
  id: string;
  name: string;
  email: string;
  passwordHash: string;
  createdAt: Date;
}

interface UserReadModel {
  id: string;
  name: string;
  email: string;
  createdAt: Date;
  orderCount?: number;
  totalSpent?: number;
}

interface CreateUserCommand {
  type: 'CREATE_USER';
  payload: { name: string; email: string; password: string };
}

interface UpdateUserCommand {
  type: 'UPDATE_USER';
  payload: { id: string; name?: string; email?: string };
}

interface DeleteUserCommand {
  type: 'DELETE_USER';
  payload: { id: string };
}

type Command = CreateUserCommand | UpdateUserCommand | DeleteUserCommand;

interface GetUserQuery {
  type: 'GET_USER';
  payload: { id: string };
}

interface ListUsersQuery {
  type: 'LIST_USERS';
  payload?: { limit?: number; offset?: number };
}

type Query = GetUserQuery | ListUsersQuery;

interface Event {
  type: string;
  payload: any;
  timestamp: Date;
}

class EventBus {
  private handlers: Map<string, (event: Event) => Promise<void>> = new Map();

  subscribe(eventType: string, handler: (event: Event) => Promise<void>): void {
    if (!this.handlers.has(eventType)) {
      this.handlers.set(eventType, []);
    }
    this.handlers.get(eventType)!.push(handler);
  }

  async publish(event: Event): Promise<void> {
    const handlers = this.handlers.get(event.type) || [];
    await Promise.all(handlers.map(h => h(event)));
  }
}

class CommandHandler {
  private writeDb: Map<string, User> = new Map();
  private eventBus: EventBus;

  constructor(eventBus: EventBus) {
    this.eventBus = eventBus;
  }

  async handle(command: Command): Promise<void> {
    switch (command.type) {
      case 'CREATE_USER':
        const user: User = {
          id: crypto.randomUUID(),
          name: command.payload.name,
          email: command.payload.email,
          passwordHash: Buffer.from(command.payload.password).toString('base64'),
          createdAt: new Date()
        };
        this.writeDb.set(user.id, user);
        await this.eventBus.publish({ type: 'USER_CREATED', payload: user, timestamp: new Date() });
        break;
      case 'UPDATE_USER':
        const existing = this.writeDb.get(command.payload.id);
        if (existing) {
          if (command.payload.name) existing.name = command.payload.name;
          if (command.payload.email) existing.email = command.payload.email;
          await this.eventBus.publish({ type: 'USER_UPDATED', payload: existing, timestamp: new Date() });
        }
        break;
      case 'DELETE_USER':
        this.writeDb.delete(command.payload.id);
        await this.eventBus.publish({ type: 'USER_DELETED', payload: { id: command.payload.id }, timestamp: new Date() });
        break;
    }
  }
}

class QueryHandler {
  private readDb: Map<string, UserReadModel> = new Map();
  private eventBus: EventBus;

  constructor(eventBus: EventBus) {
    this.eventBus = eventBus;
    this.subscribeToEvents();
  }

  private subscribeToEvents(): void {
    this.eventBus.subscribe('USER_CREATED', (event: Event) => {
      const user = event.payload as User;
      this.readDb.set(user.id, {
        id: user.id,
        name: user.name,
        email: user.email,
        createdAt: user.createdAt,
        orderCount: 0,
        totalSpent: 0
      });
    });

    this.eventBus.subscribe('USER_UPDATED', (event: Event) => {
      const user = event.payload as User;
      const readModel = this.readDb.get(user.id);
      if (readModel) {
        readModel.name = user.name;
        readModel.email = user.email;
      }
    });

    this.eventBus.subscribe('USER_DELETED', (event: Event) => {
      this.readDb.delete(event.payload.id);
    });
  }

  async handle(query: Query): Promise<any> {
    switch (query.type) {
      case 'GET_USER':
        return this.readDb.get(query.payload.id) || null;
      case 'LIST_USERS':
        return Array.from(this.readDb.values()).slice(0, query.payload?.limit || 10);
    }
  }
}

class CQRSApi {
  private commandHandler: CommandHandler;
  private queryHandler: QueryHandler;

  constructor() {
    const eventBus = new EventBus();
    this.commandHandler = new CommandHandler(eventBus);
    this.queryHandler = new QueryHandler(eventBus);
  }

  async executeCommand(command: Command): Promise<void> {
    await this.commandHandler.handle(command);
  }

  async executeQuery(query: Query): Promise<any> {
    return this.queryHandler.handle(query);
  }
}

async function main() {
  const api = new CQRSApi();

  await api.executeCommand({
    type: 'CREATE_USER',
    payload: { name: 'Alice', email: 'alice@example.com', password: 'secret123' }
  });

  const users = await api.executeQuery({
    type: 'LIST_USERS',
    payload: { limit: 10 }
  });

  console.log('Users:', users);
}

main();
```

### Cuándo Usarlo

- Sistemas con alta lectura vs escritura
- Aplicaciones que requieren vistas optimizadas
- Sistemas distribuidos
- Cuando hay diferentes modelos para lectura/escritura

### Ventajas

- Optimización independiente de lectura/escritura
- Escalabilidad flexible
- Modelos de datos optimizados por uso
- Facilita el desarrollo de vistas complejas

### Desventajas

- Complejidad eventual
- Consistencia eventual
- Duplicación de datos

---

## 6. Service Mesh

### Definición

Service Mesh es una capa de infraestructura que maneja la comunicación entre servicios en una arquitectura de microservicios. Abstrae funcionalidades como discovery, seguridad, logging, y resilience de los servicios.

### Estructura

```
┌─────────────────────────────────────────────────────────────────┐
│                      SERVICE MESH                              │
│  ┌─────────────────────────────────────────────────────────┐    │
│  │                    DATA PLANE                            │    │
│  │  ┌─────┐   ┌─────┐   ┌─────┐   ┌─────┐                   │    │
│  │  │Envoy│   │Envoy│   │Envoy│   │Envoy│   (Sidecar Proxy) │    │
│  │  └─────┘   └─────┘   └─────┘   └─────┘                   │    │
│  └─────────────────────────────────────────────────────────┘    │
│  ┌─────────────────────────────────────────────────────────┐    │
│  │                   CONTROL PLANE                         │    │
│  │  ┌─────────┐  ┌─────────┐  ┌─────────┐                   │    │
│  │  │ Service │  │  Cert   │  │  Tele-  │                   │    │
│  │  │Registry │  │Manager  │  │ metry   │                   │    │
│  │  └─────────┘  └─────────┘  └─────────┘                   │    │
│  └─────────────────────────────────────────────────────────┘    │
└─────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────┐
│  ┌─────────────┐      ┌─────────────┐      ┌─────────────┐    │
│  │  Service A  │      │  Service B  │      │  Service C  │    │
│  │  ┌───────┐  │      │  ┌───────┐  │      │  ┌───────┐  │    │
│  │  │Sidecar│ │◀────▶│  │Sidecar│ │◀────▶│  │Sidecar│ │    │
│  │  │ Proxy │ │      │  │ Proxy │ │      │  │ Proxy │ │    │
│  │  └───────┘  │      │  └───────┘  │      │  └───────┘  │    │
│  └─────────────┘      └─────────────┘      └─────────────┘    │
└─────────────────────────────────────────────────────────────────┘
```

### Ejemplo en TypeScript

```typescript
interface ServiceInstance {
  id: string;
  serviceName: string;
  address: string;
  port: number;
  healthy: boolean;
  weight: number;
}

class ServiceRegistry {
  private services: Map<string, ServiceInstance[]> = new Map();

  register(instance: ServiceInstance): void {
    if (!this.services.has(instance.serviceName)) {
      this.services.set(instance.serviceName, []);
    }
    this.services.get(instance.serviceName)!.push(instance);
    console.log(`[Registry] Registered ${instance.id} for ${instance.serviceName}`);
  }

  discover(serviceName: string): ServiceInstance[] {
    return this.services.get(serviceName)?.filter(i => i.healthy) || [];
  }
}

class CircuitBreaker {
  private failures: Map<string, number> = new Map();
  private state: Map<string, 'closed' | 'open' | 'half-open'> = new Map();
  
  constructor(private threshold: number = 5, private timeout: number = 30000) {}

  async execute<T>(serviceName: string, operation: () => Promise<T>): Promise<T> {
    if (this.state.get(serviceName) === 'open') {
      throw new Error('Circuit breaker open');
    }

    try {
      const result = await operation();
      this.failures.set(serviceName, 0);
      this.state.set(serviceName, 'closed');
      return result;
    } catch (error) {
      const current = this.failures.get(serviceName) || 0;
      this.failures.set(serviceName, current + 1);
      
      if (current + 1 >= this.threshold) {
        this.state.set(serviceName, 'open');
        setTimeout(() => this.state.set(serviceName, 'half-open'), this.timeout);
      }
      throw error;
    }
  }
}

class LoadBalancer {
  constructor(private registry: ServiceRegistry) {}

  selectInstance(serviceName: string): ServiceInstance | null {
    const instances = this.registry.discover(serviceName);
    if (instances.length === 0) return null;

    const totalWeight = instances.reduce((sum, i) => sum + i.weight, 0);
    let random = Math.random() * totalWeight;

    for (const instance of instances) {
      random -= instance.weight;
      if (random <= 0) return instance;
    }

    return instances[instances.length - 1];
  }
}

class SidecarProxy {
  constructor(
    private serviceName: string,
    private registry: ServiceRegistry,
    private circuitBreaker: CircuitBreaker
  ) {}

  async forward<T>(targetService: string, path: string): Promise<T> {
    const loadBalancer = new LoadBalancer(this.registry);
    const instance = loadBalancer.selectInstance(targetService);
    
    if (!instance) {
      throw new Error(`No available instances for ${targetService}`);
    }

    return this.circuitBreaker.execute(targetService, async () => {
      console.log(`[Sidecar ${this.serviceName}] Forwarding to ${targetService}`);
      return { success: true } as T;
    });
  }
}

class ServiceMesh {
  private registry: ServiceRegistry;

  constructor() {
    this.registry = new ServiceRegistry();
  }

  createSidecar(serviceName: string): SidecarProxy {
    return new SidecarProxy(serviceName, this.registry, new CircuitBreaker());
  }

  registerService(instance: ServiceInstance): void {
    this.registry.register(instance);
  }
}

async function main() {
  const mesh = new ServiceMesh();

  mesh.registerService({
    id: 'user-svc-1',
    serviceName: 'users',
    address: 'localhost',
    port: 3001,
    healthy: true,
    weight: 1
  });

  const sidecar = mesh.createSidecar('order-service');
  
  try {
    await sidecar.forward('/api/users', '');
  } catch (error) {
    console.error('Request failed:', (error as Error).message);
  }
}

main();
```

### Cuándo Usarlo

- Arquitecturas de microservicios complejas
- Cuando se necesita observabilidad completa
- Requisitos de seguridad estrictos entre servicios
- Equipos grandes con muchos servicios

### Ventajas

- Desacoplamiento de lógica de red
- Observabilidad automática
- Seguridad centralizada
- Resiliencia configurable

### Desventajas

- Complejidad operacional alta
- Overhead de recursos
- Curva de aprendizaje pronunciada
- Costo adicional

---

## Comparativa de Patrones

| Patrón | Complejidad | Uso Principal | Cuándo aplicarlo |
|--------|-------------|---------------|------------------|
| MVC | Baja | UI Web | Proyectos tradicionales |
| MVVM | Media | SPA/Reactivas | Apps con estado complejo |
| API Gateway | Media | Microservicios | Múltiples clientes |
| Load Balancer | Baja-Media | Alta disponibilidad | Tráfico alto |
| CQRS | Alta | Sistemas complejos | Read/Write asimétricos |
| Service Mesh | Alta | Microservicios grandes | Teams grandes |

---

## Recomendaciones

1. **Proyectos pequeños**: MVC simple o directamente con framework
2. **SPA modernas**: MVVM con tu framework favorito
3. **Microservicios simples**: API Gateway + Load Balancer
4. **Microservicios complejos**: Service Mesh completo
5. **Sistemas con alta lectura**: Considera CQRS
6. **DDD**: Combina CQRS con arquitectura hexagonal

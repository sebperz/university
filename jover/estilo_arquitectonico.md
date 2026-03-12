# Estilos Arquitectónicos

Los estilos arquitectónicos son plantillas de alto nivel que definen la estructura fundamental de una aplicación. Cada estilo impone restricciones y reglas que determinan cómo se organizan los componentes y cómo interactúan entre sí.

---

## 1. Arquitectura por Capas (Layers/N-Tier)

### Definición

La arquitectura por capas es uno de los estilos más antiguos y utilizados. Separa la aplicación en capas lógicas independientes, donde cada capa tiene una responsabilidad específica y solo se comunica con las capas adyacentes.

### Estructura

```
┌─────────────────────────────────────┐
│        Capa de Presentación         │  ← UI, Componentes, Vistas
├─────────────────────────────────────┤
│        Capa de Lógica/Negocio       │  ← Servicios, Casos de uso
├─────────────────────────────────────┤
│          Capa de Datos              │  ← Repositorios, ORM
├─────────────────────────────────────┤
│          Capa de Infraestructura    │  ← DB, APIs externas
└─────────────────────────────────────┘
```

### Ejemplo en TypeScript

```typescript
// Capa de Dominio - Entidades
interface User {
  id: string;
  name: string;
  email: string;
}

// Capa de Datos - Repositorio
interface UserRepository {
  findById(id: string): Promise<User | null>;
  save(user: User): Promise<void>;
  delete(id: string): Promise<void>;
}

// Capa de Negocio - Servicio
class UserService {
  constructor(private userRepo: UserRepository) {}

  async getUserById(id: string): Promise<User | null> {
    return this.userRepo.findById(id);
  }

  async createUser(name: string, email: string): Promise<User> {
    const user: User = {
      id: crypto.randomUUID(),
      name,
      email
    };
    await this.userRepo.save(user);
    return user;
  }

  async deleteUser(id: string): Promise<void> {
    const user = await this.userRepo.findById(id);
    if (!user) throw new Error('User not found');
    await this.userRepo.delete(id);
  }
}

// Capa de Presentación - Controlador
class UserController {
  constructor(private userService: UserService) {}

  async getUser(req: Request, res: Response) {
    const user = await this.userService.getUserById(req.params.id);
    res.json(user);
  }

  async createUser(req: Request, res: Response) {
    const user = await this.userService.createUser(
      req.body.name,
      req.body.email
    );
    res.status(201).json(user);
  }
}
```

### Cuándo Usarlo

- Aplicaciones empresariales tradicionales
- Proyectos con equipos medianos
- Cuando hay claras separation of concerns
- Aplicaciones que requieren mantenimiento a largo plazo

### Ventajas

- Fácil de entender y aprender
- Separación clara de responsabilidades
- Permite desarrollo paralelo por capas
- Fácil de probar (mocking por capa)
- Mantenimiento simplificado

### Desventajas

- Puede crear cuellos de botella
- Difícil escalar individualmente capas
- Acoplamiento temporal entre capas
- Puede generar código redundante

### Ejemplo Real

- **Amazon** (早期 - early systems)
- **Aplicaciones empresariales Java** (Spring MVC)
- **Django, Laravel** (frameworks web)

---

## 2. Arquitectura de Microservicios

### Definición

Microservicios es un enfoque arquitectónico donde una aplicación se construye como un conjunto de servicios pequeños, autónomos y desplegables de forma independiente. Cada microservicio tiene su propia base de datos y se comunica con otros mediante APIs ligeras.

### Estructura

```
┌──────────────┐    ┌──────────────┐    ┌──────────────┐
│   Servicio   │    │   Servicio   │    │  Servicio    │
│   Usuarios   │    │    Órdenes   │    │   Productos  │
│   (Puerto    │    │   (Puerto    │    │   (Puerto    │
│    3001)     │    │    3002)     │    │    3003)     │
└──────────────┘    └──────────────┘    └──────────────┘
        │                  │                  │
        └──────────────────┼──────────────────┘
                           │
                    ┌──────▼──────┐
                    │ API Gateway │
                    └─────────────┘
```

### Ejemplo en TypeScript

```typescript
// Servicio de Usuarios (users-service)
import express from 'express';
import { User, UserRepository } from './domain';

const app = express();
app.use(express.json());

// Este servicio maneja solo usuarios
class InMemoryUserRepository implements UserRepository {
  private users: Map<string, User> = new Map();

  async findById(id: string): Promise<User | null> {
    return this.users.get(id) || null;
  }

  async save(user: User): Promise<void> {
    this.users.set(user.id, user);
  }
}

// Docker compose para orquestación
// docker-compose.yml
/*
version: '3.8'
services:
  users-service:
    build: ./users
    ports:
      - "3001:3000"
  
  orders-service:
    build: ./orders
    ports:
      - "3002:3000"
  
  products-service:
    build: ./products
    ports:
      - "3003:3000"
  
  api-gateway:
    build: ./gateway
    ports:
      - "8080:8080"
*/

// Comunicación síncrona (REST)
class UserServiceClient {
  private baseUrl = process.env.ORDERS_SERVICE_URL || 'http://localhost:3002';

  async getUserOrders(userId: string) {
    const response = await fetch(`${this.baseUrl}/orders?userId=${userId}`);
    return response.json();
  }
}

// Comunicación asíncrona (Message Queue)
interface MessageQueue {
  publish(event: string, payload: any): Promise<void>;
  subscribe(event: string, handler: (payload: any) => void): void;
}

class UserEventPublisher {
  constructor(private mq: MessageQueue) {}

  async userCreated(user: User) {
    await this.mq.publish('user.created', {
      userId: user.id,
      email: user.email,
      timestamp: new Date()
    });
  }
}
```

### Cuándo Usarlo

- Aplicaciones grandes con múltiples dominios de negocio
- Equipos grandes (varios equipos de desarrollo)
- Cuando se necesita escalabilidad independiente
- Despliegue continuo y независимость de release
- Aplicaciones con múltiples tecnologías

### Ventajas

- Despliegue independiente
- Escalabilidad granular
- Tecnología heterogénea
- Equipos autónomos
- Fallo aislado
- Desarrollo paralelo

### Desventajas

- Complejidad operacional alta
- Latencia de red
- Gestión de datos distribuidos
- Testing distribuido complejo
- Consistencia eventual

### Ejemplo Real

- **Netflix** (pionero en microservicios)
- **Amazon** (evolucionó de monolith)
- **Uber** (migró de monolith a microservicios)
- **Spotify**

---

## 3. Arquitectura Microkernel (Plugin)

### Definición

La arquitectura Microkernel (también conocida como Plugin) separa el sistema en dos componentes: un núcleo minimalista (core) que contiene la funcionalidad básica del sistema, y módulos externos (plugins) que añaden características adicionales.

### Estructura

```
┌─────────────────────────────────────────────────────┐
│                    CORE SYSTEM                       │
│  ┌─────────────────────────────────────────────┐    │
│  │  • Gestión de Plugins                       │    │
│  │  • Comunicación núcleo-plugin              │    │
│  │  • Servicios fundamentales                  │    │
│  │  • Carga/Descarga de plugins                │    │
│  └─────────────────────────────────────────────┘    │
├─────────────────────────────────────────────────────┤
│  PLUGINS (Extensiones)                              │
│  ┌──────────┐ ┌──────────┐ ┌──────────┐             │
│  │ Plugin A │ │ Plugin B │ │ Plugin N │             │
│  │ (Core)    │ │ (Custom) │ │ (Custom) │             │
│  └──────────┘ └──────────┘ └──────────┘             │
└─────────────────────────────────────────────────────┘
```

### Ejemplo en TypeScript

```typescript
// Interfaz del Plugin (contrato)
interface Plugin {
  name: string;
  version: string;
  initialize(core: CoreSystem): Promise<void>;
  execute(context: ExecutionContext): Promise<any>;
  shutdown(): Promise<void>;
}

interface CoreSystem {
  registerService(name: string, service: any): void;
  getService(name: string): any;
  subscribeEvent(event: string, handler: EventHandler): void;
  publishEvent(event: string, data: any): void;
}

interface ExecutionContext {
  userId?: string;
  metadata?: Record<string, any>;
}

// Plugin de Autenticación (core)
class AuthPlugin implements Plugin {
  name = 'auth-plugin';
  version = '1.0.0';

  constructor(private jwtSecret: string) {}

  async initialize(core: CoreSystem): Promise<void> {
    core.registerService('auth', {
      verifyToken: (token: string) => this.verifyToken(token),
      generateToken: (payload: any) => this.generateToken(payload)
    });
  }

  async execute(context: ExecutionContext): Promise<any> {
    return { authenticated: true };
  }

  async shutdown(): Promise<void> {}

  private verifyToken(token: string): boolean {
    return token === this.jwtSecret;
  }

  private generateToken(payload: any): string {
    return Buffer.from(JSON.stringify(payload)).toString('base64');
  }
}

// Plugin de Notificaciones (custom)
class NotificationPlugin implements Plugin {
  name = 'notification-plugin';
  version = '1.0.0';

  async initialize(core: CoreSystem): Promise<void> {
    core.subscribeEvent('user.created', this.handleUserCreated);
    core.registerService('notification', {
      send: (type: string, message: string) => this.send(type, message)
    });
  }

  async execute(context: ExecutionContext): Promise<any> {
    return { sent: true };
  }

  async shutdown(): Promise<void> {}

  private handleUserCreated = async (data: any) => {
    await this.send('email', `Welcome ${data.email}!`);
  };

  private async send(type: string, message: string): Promise<void> {
    console.log(`[${type}] ${message}`);
  }
}

// Sistema Core
class Kernel implements CoreSystem {
  private services: Map<string, any> = new Map();
  private plugins: Map<string, Plugin> = new Map();
  private eventHandlers: Map<string, EventHandler[]> = new Map();

  async loadPlugin(plugin: Plugin): Promise<void> {
    await plugin.initialize(this);
    this.plugins.set(plugin.name, plugin);
    console.log(`Plugin loaded: ${plugin.name} v${plugin.version}`);
  }

  async unloadPlugin(name: string): Promise<void> {
    const plugin = this.plugins.get(name);
    if (plugin) {
      await plugin.shutdown();
      this.plugins.delete(name);
    }
  }

  registerService(name: string, service: any): void {
    this.services.set(name, service);
  }

  getService(name: string): any {
    return this.services.get(name);
  }

  subscribeEvent(event: string, handler: EventHandler): void {
    if (!this.eventHandlers.has(event)) {
      this.eventHandlers.set(event, []);
    }
    this.eventHandlers.get(event)!.push(handler);
  }

  publishEvent(event: string, data: any): void {
    const handlers = this.eventHandlers.get(event) || [];
    handlers.forEach(handler => handler(data));
  }
}

// Uso
async function main() {
  const kernel = new Kernel();
  
  await kernel.loadPlugin(new AuthPlugin('secret-key'));
  await kernel.loadPlugin(new NotificationPlugin());
  
  const auth = kernel.getService('auth');
  const token = auth.generateToken({ userId: '123' });
  
  kernel.publishEvent('user.created', { email: 'test@example.com' });
}
```

### Cuándo Usarlo

- Sistemas extensibles (IDEs, navegadores)
- Plataformas que necesitan plugins de terceros
- Aplicaciones con funcionalidades opcionales
- Productos que evolucionan con módulos independientes

### Ventajas

- Extensibilidad sin modificar el core
- Modularidad
- Despliegue independiente de plugins
- Flexibilidad para personalización
- Fácil evolución del sistema

### Desventajas

- Overhead de comunicación
- Complejidad en gestión de plugins
- Posible inconsistencia entre plugins
- Performance pueden verse afectada

### Ejemplo Real

- **VS Code** (sistema de extensiones)
- **Jenkins** (plugins de CI/CD)
- **Eclipse IDE**
- **Navegadores web** (Chrome, Firefox)

---

## 4. Arquitectura Event-Driven (EDA)

### Definición

La arquitectura orientada a eventos es un paradigma donde los componentes del sistema se comunican mediante la emisión y recepción de eventos. Los productores de eventos no conocen a los consumidores, permitiendo un acoplamiento débil y sistemas altamente escalables.

### Estructura

```
┌─────────────┐     ┌─────────────┐     ┌─────────────┐
│  Productor │────▶│   Message   │────▶│  Consumidor │
│  (Events)  │     │    Queue    │     │  (Handlers) │
└─────────────┘     └─────────────┘     └─────────────┘
       │                   │                   │
       │                   │                   │
       ▼                   ▼                   ▼
  ┌─────────┐        ┌──────────┐        ┌──────────┐
  │  Order  │        │  Kafka/  │        │  Email   │
  │ Created │        │  Rabbit  │        │  Service │
  └─────────┘        │ MQ/SNS   │        └──────────┘
                     └──────────┘
```

### Ejemplo en TypeScript

```typescript
// Tipos de eventos
interface Event {
  type: string;
  payload: any;
  timestamp: Date;
  correlationId: string;
}

interface OrderCreatedEvent extends Event {
  type: 'ORDER_CREATED';
  payload: {
    orderId: string;
    userId: string;
    items: Array<{ productId: string; quantity: number }>;
    total: number;
  };
}

// Event Bus (Pub/Sub)
type EventHandler<T extends Event> = (event: T) => Promise<void>;

class EventBus {
  private handlers: Map<string, EventHandler<Event>[]> = new Map();

  subscribe<T extends Event>(
    eventType: string,
    handler: EventHandler<T>
  ): void {
    if (!this.handlers.has(eventType)) {
      this.handlers.set(eventType, []);
    }
    this.handlers.get(eventType)!.push(handler as EventHandler<Event>);
  }

  async publish<T extends Event>(event: T): Promise<void> {
    const handlers = this.handlers.get(event.type) || [];
    await Promise.all(handlers.map(handler => handler(event)));
  }
}

// Productor de eventos
class OrderService {
  constructor(private eventBus: EventBus) {}

  async createOrder(userId: string, items: any[]): Promise<string> {
    const orderId = crypto.randomUUID();
    const total = items.reduce((sum, item) => sum + item.price, 0);

    const orderCreatedEvent: OrderCreatedEvent = {
      type: 'ORDER_CREATED',
      payload: { orderId, userId, items, total },
      timestamp: new Date(),
      correlationId: orderId
    };

    await this.eventBus.publish(orderCreatedEvent);
    return orderId;
  }
}

// Consumidores de eventos
class NotificationHandler {
  constructor(private eventBus: EventBus) {
    this.subscribe();
  }

  private subscribe() {
    this.eventBus.subscribe<OrderCreatedEvent>(
      'ORDER_CREATED',
      this.handleOrderCreated
    );
  }

  private handleOrderCreated = async (event: OrderCreatedEvent) => {
    console.log(`Sending email notification for order ${event.payload.orderId}`);
    // Lógica de envío de email
  };
}

class InventoryHandler {
  constructor(private eventBus: EventBus) {
    this.subscribe();
  }

  private subscribe() {
    this.eventBus.subscribe<OrderCreatedEvent>(
      'ORDER_CREATED',
      this.handleOrderCreated
    );
  }

  private handleOrderCreated = async (event: OrderCreatedEvent) => {
    console.log(`Updating inventory for order ${event.payload.orderId}`);
    // Lógica de inventario
  };
}

class AnalyticsHandler {
  constructor(private eventBus: EventBus) {
    this.subscribe();
  }

  private subscribe() {
    this.eventBus.subscribe<OrderCreatedEvent>(
      'ORDER_CREATED',
      this.handleOrderCreated
    );
  }

  private handleOrderCreated = async (event: OrderCreatedEvent) => {
    console.log(`Recording analytics for order ${event.payload.orderId}`);
    // Lógica de analytics
  };
}

// Uso
async function main() {
  const eventBus = new EventBus();
  
  new NotificationHandler(eventBus);
  new InventoryHandler(eventBus);
  new AnalyticsHandler(eventBus);
  
  const orderService = new OrderService(eventBus);
  const orderId = await orderService.createOrder('user-123', [
    { productId: 'prod-1', price: 100, quantity: 2 }
  ]);
  
  console.log(`Order created: ${orderId}`);
}
```

### Cuándo Usarlo

- Sistemas con alta并发 (concurrencia)
- Procesamiento en tiempo real
- Microservicios con comunicación asíncrona
- Cuando se necesita decoupling fuerte
- Sistemas de analytics y logging

### Ventajas

- Bajo acoplamiento
- Alta escalabilidad
- Respuesta en tiempo real
- Resiliencia (cola de mensajes)
- Extensibilidad fácil

### Desventajas

- Complejidad en debugging
- Consistencia eventual
- Duplicación de eventos
- Gestión de fallos compleja

### Ejemplo Real

- **Uber** (actualización de ubicación en tiempo real)
- **LinkedIn** (feed de actividades)
- **Netflix** (recomendaciones en tiempo real)
- **Discord** (mensajería en tiempo real)

---

## 5. Arquitectura Hexagonal (Puertos y Adaptadores)

### Definición

La arquitectura hexagonal (también conocida como Ports and Adapters) busca crear aplicaciones donde el código de dominio sea el centro, independiente de cualquier infraestructura externa. Los "puertos" definen interfaces de entrada/salida, y los "adaptadores" implementan esas interfaces.

### Estructura

```
                    ┌─────────────────────┐
                    │   UI / Controlador  │
                    │     (Adaptador)     │
                    └──────────┬──────────┘
                               │
                    ┌──────────▼──────────┐
                    │   Puerto de Entrada │
                    │    (Interfaces)     │
                    └──────────┬──────────┘
                               │
         ┌─────────────────────┼─────────────────────┐
         │                     │                     │
         ▼                     ▼                     ▼
┌─────────────────┐  ┌─────────────────┐  ┌─────────────────┐
│   Aplicación    │  │    Dominio      │  │    Aplicación   │
│   (Casos de     │  │   (Entidades,   │  │   (Casos de     │
│    Uso)         │  │    Servicios)   │  │    Uso)         │
└─────────────────┘  └─────────────────┘  └─────────────────┘
         │                     │                     │
         └─────────────────────┼─────────────────────┘
                               │
                    ┌──────────▼──────────┐
                    │   Puerto de Salida  │
                    │    (Interfaces)     │
                    └──────────┬──────────┘
                               │
                    ┌──────────▼──────────┐
                    │  Base de Datos /    │
                    │   APIs Externas     │
                    │    (Adaptadores)    │
                    └─────────────────────┘
```

### Ejemplo en TypeScript

```typescript
// ==================== DOMINIO (Core) ====================

// Entidad del dominio
class Order {
  constructor(
    public readonly id: string,
    public readonly userId: string,
    public items: OrderItem[],
    public status: OrderStatus,
    public readonly createdAt: Date
  ) {}

  addItem(productId: string, quantity: number, price: number): void {
    this.items.push({ productId, quantity, price });
  }

  getTotal(): number {
    return this.items.reduce((sum, item) => sum + item.price * item.quantity, 0);
  }

  complete(): void {
    if (this.items.length === 0) {
      throw new Error('Cannot complete empty order');
    }
    this.status = 'COMPLETED';
  }
}

interface OrderItem {
  productId: string;
  quantity: number;
  price: number;
}

type OrderStatus = 'PENDING' | 'COMPLETED' | 'CANCELLED';

// Servicio de dominio
class OrderDomainService {
  createOrder(userId: string): Order {
    return new Order(
      crypto.randomUUID(),
      userId,
      [],
      'PENDING',
      new Date()
    );
  }
}

// ==================== PUERTOS (Interfaces) ====================

// Puerto de entrada (input port)
interface CreateOrderUseCase {
  execute(input: CreateOrderInput): Promise<OrderOutput>;
}

interface CreateOrderInput {
  userId: string;
  items: Array<{ productId: string; quantity: number }>;
}

interface OrderOutput {
  id: string;
  userId: string;
  total: number;
  status: string;
}

// Puerto de salida (output port)
interface OrderRepository {
  save(order: Order): Promise<void>;
  findById(id: string): Promise<Order | null>;
  findByUserId(userId: string): Promise<Order[]>;
}

interface PaymentGateway {
  processPayment(userId: string, amount: number): Promise<PaymentResult>;
}

interface PaymentResult {
  success: boolean;
  transactionId?: string;
  error?: string;
}

// ==================== APLICACIÓN (Casos de Uso) ====================

class CreateOrderUseCaseImpl implements CreateOrderUseCase {
  constructor(
    private orderRepository: OrderRepository,
    private paymentGateway: PaymentGateway,
    private domainService: OrderDomainService
  ) {}

  async execute(input: CreateOrderInput): Promise<OrderOutput> {
    // 1. Crear orden en dominio
    const order = this.domainService.createOrder(input.userId);
    
    // 2. Agregar items (simulado)
    input.items.forEach(item => {
      order.addItem(item.productId, item.quantity, 100); // precio fijo
    });
    
    // 3. Procesar pago
    const payment = await this.paymentGateway.processPayment(
      input.userId,
      order.getTotal()
    );
    
    if (!payment.success) {
      throw new Error(`Payment failed: ${payment.error}`);
    }
    
    // 4. Completar orden
    order.complete();
    
    // 5. Persistir
    await this.orderRepository.save(order);
    
    return {
      id: order.id,
      userId: order.userId,
      total: order.getTotal(),
      status: order.status
    };
  }
}

// ==================== ADAPTADORES (Infraestructura) ====================

// Adaptador de base de datos (MySQL/PostgreSQL)
class MySQLOrderRepository implements OrderRepository {
  private orders: Map<string, Order> = new Map();

  async save(order: Order): Promise<void> {
    this.orders.set(order.id, order);
    console.log(`[MySQL] Order saved: ${order.id}`);
  }

  async findById(id: string): Promise<Order | null> {
    return this.orders.get(id) || null;
  }

  async findByUserId(userId: string): Promise<Order[]> {
    return Array.from(this.orders.values()).filter(o => o.userId === userId);
  }
}

// Adaptador de API externa (Stripe)
class StripePaymentGateway implements PaymentGateway {
  async processPayment(userId: string, amount: number): Promise<PaymentResult> {
    console.log(`[Stripe] Processing payment: $${amount} for user ${userId}`);
    return {
      success: true,
      transactionId: `txn_${crypto.randomUUID()}`
    };
  }
}

// Adaptador de REST API
import express from 'express';

class OrderController {
  constructor(private createOrderUseCase: CreateOrderUseCase) {}

  async handleRequest(req: express.Request, res: express.Response) {
    try {
      const result = await this.createOrderUseCase.execute({
        userId: req.body.userId,
        items: req.body.items
      });
      res.status(201).json(result);
    } catch (error) {
      res.status(400).json({ error: (error as Error).message });
    }
  }
}

// ==================== INYECCIÓN DE DEPENDENCIAS ====================

function createApplication(): CreateOrderUseCase {
  const orderRepository: OrderRepository = new MySQLOrderRepository();
  const paymentGateway: PaymentGateway = new StripePaymentGateway();
  const domainService = new OrderDomainService();

  return new CreateOrderUseCaseImpl(
    orderRepository,
    paymentGateway,
    domainService
  );
}

// Uso
async function main() {
  const createOrderUseCase = createApplication();
  const controller = new OrderController(createOrderUseCase);
  
  // Simular request HTTP
  const mockRequest = {
    body: {
      userId: 'user-123',
      items: [
        { productId: 'prod-1', quantity: 2 },
        { productId: 'prod-2', quantity: 1 }
      ]
    }
  } as express.Request;
  
  const mockResponse = {
    status: function(code: number) { return this; },
    json: function(data: any) { console.log('Response:', data); }
  } as express.Response;
  
  await controller.handleRequest(mockRequest, mockResponse);
}
```

### Cuándo Usarlo

- Aplicaciones empresariales complejas
- Cuando el dominio es el centro del desarrollo (DDD)
- Sistemas que evolucionan frecuentemente
- Cuando necesitas testar el dominio sin infraestructura
- Aplicaciones con múltiples fuentes de datos

### Ventajas

- Código de dominio limpio y testeable
- Independencia de infraestructura
- Fácil cambiar implementaciones
- Alta cohesión, bajo acoplamiento
-Excelente para DDD

### Desventajas

- Curva de aprendizaje alta
- Overhead para aplicaciones simples
- Puede ser overkill para proyectos pequeños

### Ejemplo Real

- **NestJS** (framework basado en esta arquitectura)
- **Domain-Driven Design** implementations
- **Ports & Adapters** en banking/fintech

---

## Comparativa de Estilos

| Característica | Capas | Microservicios | Microkernel | Event-Driven | Hexagonal |
|----------------|-------|----------------|-------------|--------------|-----------|
| **Complejidad** | Baja | Alta | Media | Media | Media-Alta |
| **Escalabilidad** | Vertical | Horizontal | Modular | Horizontal | Modular |
| **Acoplamiento** | Alto | Bajo | Bajo | Muy Bajo | Bajo |
| **Testing** | Medio | Complejo | Medio | Medio | Fácil |
| **Curva aprendizaje** | Baja | Alta | Media | Media | Alta |
| **Mejor para** | MVP, Pequeños | Grandes sistemas | Plugins | Tiempo real | Dominio complejo |

---

## Recomendaciones por Tipo de Proyecto

| Proyecto | Estilo Recomendado |
|----------|-------------------|
| Startup con MVP | Capas |
| Proyecto académico | Capas / Hexagonal |
| SaaS empresarial | Microservicios / Hexagonal |
| IDE / Herramienta extensible | Microkernel |
| Sistema de trading | Event-Driven |
| Sistema legacy moderno | Capas → Hexagonal |

---

## Conclusión

No existe un estilo arquitectónico "mejor" que otro. La elección depende de:

1. **Tamaño del equipo** - Equipos pequeños = estilos simples
2. **Escalabilidad requerida** - Microservicios para alta escala
3. **Naturaleza del dominio** - DDD → Hexagonal
4. **Frecuencia de cambios** - Microkernel para sistemas extensibles
5. **Requisitos tiempo real** - Event-Driven

Los estilos pueden combinarse: una arquitectura hexagonal dentro de microservicios, oEvent-Driven con servicios core.

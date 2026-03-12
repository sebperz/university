# Patrones de Diseño (Design Patterns)

Los patrones de diseño son soluciones reutilizables a problemas comunes en el diseño de software. Fueron documentados por primera vez en el libro "Design Patterns: Elements of Reusable Object-Oriented Software" (Gang of Four - GoF).

---

## PATRONES CREACIONALES

Los patrones creacionales se centran en el proceso de creación de objetos, proporcionando mecanismos para crear objetos de manera flexible y reutilizable.

---

## 1. Singleton

### Definición

Garantiza que una clase tenga solo una instancia y proporciona un punto de acceso global a ella.

### Diagrama

```
┌─────────────────────────────┐
│       Singleton             │
├─────────────────────────────┤
│ - instance: Singleton      │
├─────────────────────────────┤
│ + getInstance(): Singleton │◄─────────┐
│ + someMethod(): void       │          │
└─────────────────────────────┘          │
                                          │
              ┌───────────────────────────┘
              │ (returns same instance)
              ▼
        ┌───────────┐
        │  Client   │
        └───────────┘
```

### Ejemplo en TypeScript

```typescript
// ==================== IMPLEMENTACIÓN BÁSICA ====================

class DatabaseConnection {
  private static instance: DatabaseConnection;
  private connection: any;

  private constructor() {
    this.connection = 'Connected to database';
    console.log('Database connection established');
  }

  static getInstance(): DatabaseConnection {
    if (!DatabaseConnection.instance) {
      DatabaseConnection.instance = new DatabaseConnection();
    }
    return DatabaseConnection.instance;
  }

  query(sql: string): void {
    console.log(`Executing: ${sql}`);
  }

  disconnect(): void {
    console.log('Disconnected from database');
  }
}

// Uso
const db1 = DatabaseConnection.getInstance();
const db2 = DatabaseConnection.getInstance();

console.log(db1 === db2); // true - misma instancia
db1.query('SELECT * FROM users');


// ==================== IMPLEMENTACIÓN CON THREAD-SAFETY (Lazy) ====================

class LazySingleton {
  private static instance: LazySingleton | null = null;
  private static lock = false;

  private constructor() {
    console.log('LazySingleton created');
  }

  static getInstance(): LazySingleton {
    if (!LazySingleton.instance) {
      if (!LazySingleton.lock) {
        LazySingleton.lock = true;
        LazySingleton.instance = new LazySingleton();
      }
    }
    return LazySingleton.instance!;
  }

  doSomething(): void {
    console.log('Singleton method called');
  }
}


// ==================== IMPLEMENTACIÓN CON METADATA ====================

function Singleton<T extends { new (...args: any[]): any }>(constructor: T): any {
  const instanceMap = new WeakMap<T, InstanceType<T>>();

  return class extends constructor {
    static getInstance(...args: any[]): InstanceType<T> {
      if (!instanceMap.has(constructor)) {
        instanceMap.set(constructor, new constructor(...args));
      }
      return instanceMap.get(constructor)!;
    }

    static resetInstance(): void {
      instanceMap.delete(constructor);
    }
  };
}

@Singleton
class ConfigManager {
  constructor(public env: string = 'development') {
    console.log(`ConfigManager initialized for ${env}`);
  }

  get(key: string): string {
    return `value_${key}`;
  }
}

const config1 = ConfigManager.getInstance('production');
const config2 = ConfigManager.getInstance('staging');

console.log(config1.env); // 'production' - ignorado, misma instancia
console.log(config1 === config2); // true


// ==================== EJEMPLO PRÁCTICO: CACHE ====================

class CacheManager {
  private static instance: CacheManager;
  private cache: Map<string, { value: any; expiry: number }> = new Map();

  private constructor() {}

  static getInstance(): CacheManager {
    if (!CacheManager.instance) {
      CacheManager.instance = new CacheManager();
    }
    return CacheManager.instance;
  }

  set(key: string, value: any, ttlMs: number = 60000): void {
    this.cache.set(key, {
      value,
      expiry: Date.now() + ttlMs
    });
  }

  get(key: string): any | null {
    const item = this.cache.get(key);
    if (!item) return null;
    
    if (Date.now() > item.expiry) {
      this.cache.delete(key);
      return null;
    }
    
    return item.value;
  }

  clear(): void {
    this.cache.clear();
  }

  size(): number {
    return this.cache.size;
  }
}

// Uso
const cache = CacheManager.getInstance();
cache.set('user:1', { name: 'Alice', age: 30 });
cache.set('user:2', { name: 'Bob', age: 25 }, 5000);

console.log(cache.get('user:1')); // { name: 'Alice', age: 30 }
console.log(cache.get('user:2')); // { name: 'Bob', age: 25 }

setTimeout(() => {
  console.log(cache.get('user:2')); // null - expiró
}, 6000);
```

### Cuándo Usarlo

- Conexiones a bases de datos
- Configuraciones globales
- Logging
- Cache de aplicación
- Colas de mensajes

### Ventajas

- Control total sobre la instancia
- Acceso global garantizado
- Lazy initialization opcional

### Desventajas

- Dificulta el testing
- Puede ocultar dependencias
- Violación del principio SRP en sistemas distribuidos

---

## 2. Factory Method

### Definición

Define una interfaz para crear un objeto, pero permite a las subclases decidir qué clase instanciar.

### Diagrama

```
         ┌─────────────────┐
         │    Creator      │
         │ (Abstract)      │
         ├─────────────────┤
         │ + factoryMethod │◄─────────────┐
         │ + someOperation │               │
         └────────┬────────┘               │
                  │                        │
       ┌──────────┴──────────┐    ┌─────────┴─────────┐
       ▼                     ▼    ▼                   ▼
┌─────────────┐    ┌─────────────┐  ┌─────────────┐ ┌─────────────┐
│ConcreteCret1│    │ConcreteCret2│  │ Product      │ │Product      │
│             │───▶│             │──│(Interface)   │ │(Interface)  │
└─────────────┘    └─────────────┘  └──────────────┘ └──────────────┘
```

### Ejemplo en TypeScript

```typescript
// ==================== INTERFAZ PRODUCTO ====================

interface Notification {
  send(message: string): void;
  getChannel(): string;
}

// ==================== PRODUCTOS CONCRETOS ====================

class EmailNotification implements Notification {
  send(message: string): void {
    console.log(`[EMAIL] Sending: ${message}`);
  }

  getChannel(): string {
    return 'email';
  }
}

class SMSNotification implements Notification {
  send(message: string): void {
    console.log(`[SMS] Sending: ${message}`);
  }

  getChannel(): string {
    return 'sms';
  }
}

class PushNotification implements Notification {
  send(message: string): void {
    console.log(`[PUSH] Sending: ${message}`);
  }

  getChannel(): string {
    return 'push';
  }
}

class SlackNotification implements Notification {
  send(message: string): void {
    console.log(`[SLACK] Sending: ${message}`);
  }

  getChannel(): string {
    return 'slack';
  }
}

// ==================== CREATOR ABSTRACTO ====================

abstract class NotificationCreator {
  abstract createNotification(): Notification;

  notify(message: string): void {
    const notification = this.createNotification();
    console.log(`Via ${notification.getChannel()}:`);
    notification.send(message);
  }
}

// ==================== CREATORS CONCRETOS ====================

class EmailNotificationCreator extends NotificationCreator {
  createNotification(): Notification {
    return new EmailNotification();
  }
}

class SMSNotificationCreator extends NotificationCreator {
  createNotification(): Notification {
    return new SMSNotification();
  }
}

class PushNotificationCreator extends NotificationCreator {
  createNotification(): Notification {
    return new PushNotification();
  }
}

// ==================== FACTORY CON SWITCH ====================

class NotificationFactory {
  static create(type: string): Notification {
    switch (type.toLowerCase()) {
      case 'email':
        return new EmailNotification();
      case 'sms':
        return new SMSNotification();
      case 'push':
        return new PushNotification();
      case 'slack':
        return new SlackNotification();
      default:
        throw new Error(`Unknown notification type: ${type}`);
    }
  }
}

// Uso con Factory Method
const emailCreator = new EmailNotificationCreator();
emailCreator.notify('Hello via Email!');

const smsCreator = new SMSNotificationCreator();
smsCreator.notify('Hello via SMS!');

// Uso con Factory Simple
const notification = NotificationFactory.create('slack');
notification.send('Hello from Slack!');


// ==================== EJEMPLO PRÁCTICO: DOCUMENTOS ====================

interface Document {
  open(): void;
  save(): void;
  getExtension(): string;
}

class PDFDocument implements Document {
  open(): void { console.log('Opening PDF...'); }
  save(): void { console.log('Saving PDF...'); }
  getExtension(): string { return '.pdf'; }
}

class WordDocument implements Document {
  open(): void { console.log('Opening Word...'); }
  save(): void { console.log('Saving Word...'); }
  getExtension(): string { return '.docx'; }
}

class SpreadsheetDocument implements Document {
  open(): void { console.log('Opening Spreadsheet...'); }
  save(): void { console.log('Saving Spreadsheet...'); }
  getExtension(): string { return '.xlsx'; }
}

abstract class DocumentCreator {
  abstract createDocument(): Document;

  openDocument(): void {
    const doc = this.createDocument();
    doc.open();
  }

  saveDocument(): void {
    const doc = this.createDocument();
    doc.save();
  }
}

class PDFDocumentCreator extends DocumentCreator {
  createDocument(): Document {
    return new PDFDocument();
  }
}

class WordDocumentCreator extends DocumentCreator {
  createDocument(): Document {
    return new WordDocument();
  }
}

// Factory with registry
class DocumentFactory {
  private static creators: Map<string, () => Document> = new Map();

  static register(type: string, creator: () => Document): void {
    DocumentFactory.creators.set(type, creator);
  }

  static create(type: string): Document {
    const creator = DocumentFactory.creators.get(type);
    if (!creator) throw new Error(`Unknown document type: ${type}`);
    return creator();
  }
}

DocumentFactory.register('pdf', () => new PDFDocument());
DocumentFactory.register('word', () => new WordDocument());
DocumentFactory.register('spreadsheet', () => new SpreadsheetDocument());

const doc = DocumentFactory.create('pdf');
doc.open();
console.log(doc.getExtension());
```

### Cuándo Usarlo

- Cuando una clase no puede anticipar la clase de objetos que debe crear
- Cuando las subclases deben especificar los objetos que crean
- Para delegar responsabilidad a subclases

### Ventajas

- Código más limpio
- Desacoplamiento
- Extensibilidad fácil
- SRP - lio远离创建逻辑

### Desventajas

- Puede generar muchas subclases
- Puede ser overkill para casos simples

---

## 3. Abstract Factory

### Definición

Proporciona una interfaz para crear familias de objetos relacionados sin especificar sus clases concretas.

### Diagrama

```
        ┌──────────────────────┐
        │  AbstractFactory     │
        │  + createProductA()  │
        │  + createProductB()  │
        └──────────┬───────────┘
                   │
     ┌─────────────┴─────────────┐
     │                           │
┌────▼─────┐               ┌────▼─────┐
│Factory1  │               │Factory2  │
├──────────┤               ├──────────┤
│+create.. │               │+create.. │
└────┬─────┘               └────┬─────┘
     │                           │
     ▼                           ▼
┌─────────┐  ┌──────────┐  ┌─────────┐  ┌──────────┐
│ProductA1│  │ProductB1 │  │ProductA2│  │ProductB2 │
└─────────┘  └──────────┘  └─────────┘  └──────────┘
```

### Ejemplo en TypeScript

```typescript
// ==================== PRODUCTOS ABSTRACTOS ====================

interface Button {
  render(): void;
  onClick(handler: () => void): void;
}

interface Checkbox {
  render(): void;
  onChange(handler: (checked: boolean) => void): void;
}

interface Input {
  render(): void;
  setValue(value: string): void;
}

// ==================== PRODUCTOS CONCRETOS (Windows) ====================

class WindowsButton implements Button {
  render(): void { console.log('Rendering Windows button'); }
  onClick(handler: () => void): void { console.log('Windows click'); handler(); }
}

class WindowsCheckbox implements Checkbox {
  render(): void { console.log('Rendering Windows checkbox'); }
  onChange(handler: (checked: boolean) => void): void { 
    console.log('Windows change'); 
    handler(true); 
  }
}

class WindowsInput implements Input {
  render(): void { console.log('Rendering Windows input'); }
  setValue(value: string): void { console.log(`Windows input: ${value}`); }
}

// ==================== PRODUCTOS CONCRETOS (MacOS) ====================

class MacOSButton implements Button {
  render(): void { console.log('Rendering MacOS button'); }
  onClick(handler: () => void): void { console.log('MacOS click'); handler(); }
}

class MacOSCheckbox implements Checkbox {
  render(): void { console.log('Rendering MacOS checkbox'); }
  onChange(handler: (checked: boolean) => void): void { 
    console.log('MacOS change'); 
    handler(true); 
  }
}

class MacOSInput implements Input {
  render(): void { console.log('Rendering MacOS input'); }
  setValue(value: string): void { console.log(`MacOS input: ${value}`); }
}

// ==================== FACTORY ABSTRACTA ====================

interface UIFactory {
  createButton(): Button;
  createCheckbox(): Checkbox;
  createInput(): Input;
}

// ==================== FACTORIES CONCRETAS ====================

class WindowsFactory implements UIFactory {
  createButton(): Button { return new WindowsButton(); }
  createCheckbox(): Checkbox { return new WindowsCheckbox(); }
  createInput(): Input { return new WindowsInput(); }
}

class MacOSFactory implements UIFactory {
  createButton(): Button { return new MacOSButton(); }
  createCheckbox(): Checkbox { return new MacOSCheckbox(); }
  createInput(): Input { return new MacOSInput(); }
}

// ==================== CLIENTE ====================

class Application {
  private button: Button;
  private checkbox: Checkbox;
  private input: Input;

  constructor(private factory: UIFactory) {
    this.button = factory.createButton();
    this.checkbox = factory.createCheckbox();
    this.input = factory.createInput();
  }

  render(): void {
    console.log('--- Rendering UI ---');
    this.button.render();
    this.checkbox.render();
    this.input.render();
  }

  setupHandlers(): void {
    this.button.onClick(() => console.log('Button clicked!'));
    this.checkbox.onChange(checked => console.log(`Checkbox: ${checked}`));
    this.input.setValue('Hello World');
  }
}

// Uso
function createApp(os: string): Application {
  const factory = os === 'windows' 
    ? new WindowsFactory() 
    : new MacOSFactory();
  return new Application(factory);
}

const windowsApp = createApp('windows');
windowsApp.render();
windowsApp.setupHandlers();

console.log('\n');

const macApp = createApp('macos');
macApp.render();
macApp.setupHandlers();
```

### Cuándo Usarlo

- Cuando el sistema debe ser independiente de cómo se crean los productos
- Cuando necesitas trabajar con múltiples familias de productos
- Cuando quieres proporcionar una biblioteca sin exponer implementación

### Ventajas

- Aislamiento del código concreto
- Fácil intercambio de familias de productos
- Consistencia entre productos

### Desventajas

- Dificultad para soportar nuevos tipos de productos
- Puede generar muchas clases

---

## 4. Builder

### Definición

Separa la construcción de un objeto complejo de su representación, permitiendo crear diferentes representaciones.

### Diagrama

```
┌─────────────┐     ┌─────────────┐
│   Director  │────▶│   Builder   │
│             │     │(Abstract)   │
└─────────────┘     ├─────────────┤
                   │+buildPart()  │
                   │+getResult() │
                   └──────┬───────┘
                          │
        ┌─────────────────┼─────────────────┐
        ▼                 ▼                 ▼
┌─────────────┐    ┌─────────────┐    ┌─────────────┐
│ConcreteBuild│    │ConcreteBuild│    │   Product   │
│     er1     │    │     er2     │───▶│              │
└─────────────┘    └─────────────┘    └─────────────┘
```

### Ejemplo en TypeScript

```typescript
// ==================== PRODUCTO ====================

class Pizza {
  constructor(
    public size: string = 'medium',
    public crust: string = 'regular',
    public cheese: boolean = false,
    public pepperoni: boolean = false,
    public mushrooms: boolean = false,
    public olives: boolean = false
  ) {}

  describe(): void {
    const toppings: string[] = [];
    if (this.pepperoni) toppings.push('pepperoni');
    if (this.mushrooms) toppings.push('mushrooms');
    if (this.olives) toppings.push('olives');
    
    console.log(`🍕 ${this.size} pizza with ${this.crust} crust, ` +
      `${this.cheese ? 'cheese' : 'no cheese'}, ${toppings.join(', ') || 'no toppings'}`);
  }
}

// ==================== BUILDER ABSTRACTO ====================

interface PizzaBuilder {
  setSize(size: string): PizzaBuilder;
  setCrust(crust: string): PizzaBuilder;
  addCheese(): PizzaBuilder;
  addPepperoni(): PizzaBuilder;
  addMushrooms(): PizzaBuilder;
  addOlives(): PizzaBuilder;
  build(): Pizza;
  getPizza(): Pizza;
}

// ==================== BUILDERS CONCRETOS ====================

class MargheritaBuilder implements PizzaBuilder {
  private pizza: Pizza;

  constructor() {
    this.pizza = new Pizza();
  }

  setSize(size: string): PizzaBuilder {
    this.pizza.size = size;
    return this;
  }

  setCrust(crust: string): PizzaBuilder {
    this.pizza.crust = crust;
    return this;
  }

  addCheese(): PizzaBuilder {
    this.pizza.cheese = true;
    return this;
  }

  addPepperoni(): PizzaBuilder { return this; }
  addMushrooms(): PizzaBuilder { return this; }
  addOlives(): PizzaBuilder { return this; }

  build(): Pizza {
    const result = this.pizza;
    this.pizza = new Pizza();
    return result;
  }

  getPizza(): Pizza {
    return this.pizza;
  }
}

class PepperoniBuilder implements PizzaBuilder {
  private pizza: Pizza;

  constructor() {
    this.pizza = new Pizza();
  }

  setSize(size: string): PizzaBuilder {
    this.pizza.size = size;
    return this;
  }

  setCrust(crust: string): PizzaBuilder {
    this.pizza.crust = crust;
    return this;
  }

  addCheese(): PizzaBuilder {
    this.pizza.cheese = true;
    return this;
  }

  addPepperoni(): PizzaBuilder {
    this.pizza.pepperoni = true;
    return this;
  }

  addMushrooms(): PizzaBuilder { return this; }
  addOlives(): PizzaBuilder { return this; }

  build(): Pizza {
    const result = this.pizza;
    this.pizza = new Pizza();
    return result;
  }

  getPizza(): Pizza {
    return this.pizza;
  }
}

class CustomPizzaBuilder implements PizzaBuilder {
  private pizza: Pizza;

  constructor() {
    this.pizza = new Pizza();
  }

  setSize(size: string): PizzaBuilder {
    this.pizza.size = size;
    return this;
  }

  setCrust(crust: string): PizzaBuilder {
    this.pizza.crust = crust;
    return this;
  }

  addCheese(): PizzaBuilder {
    this.pizza.cheese = true;
    return this;
  }

  addPepperoni(): PizzaBuilder {
    this.pizza.pepperoni = true;
    return this;
  }

  addMushrooms(): PizzaBuilder {
    this.pizza.mushrooms = true;
    return this;
  }

  addOlives(): PizzaBuilder {
    this.pizza.olives = true;
    return this;
  }

  build(): Pizza {
    const result = this.pizza;
    this.pizza = new Pizza();
    return result;
  }

  getPizza(): Pizza {
    return this.pizza;
  }
}

// ==================== DIRECTOR ====================

class PizzaDirector {
  private builder: PizzaBuilder;

  constructor(builder: PizzaBuilder) {
    this.builder = builder;
  }

  setBuilder(builder: PizzaBuilder): void {
    this.builder = builder;
  }

  makeMargherita(): void {
    this.builder.setSize('large').setCrust('thin').addCheese();
  }

  makePepperoni(): void {
    this.builder.setSize('medium').setCrust('pan').addCheese().addPepperoni();
  }

  makeVegetarian(): void {
    this.builder.setSize('small').setCrust('stuffed')
      .addCheese().addMushrooms().addOlives();
  }
}

// Uso
const customBuilder = new CustomPizzaBuilder();
const director = new PizzaDirector(customBuilder);

director.makeMargherita();
customBuilder.build().describe();

director.makePepperoni();
customBuilder.build().describe();

director.makeVegetarian();
customBuilder.build().describe();

// Uso directo del builder
console.log('\n--- Custom Pizza ---');
const custom = new CustomPizzaBuilder();
custom.setSize('large').setCrust('thin').addCheese().addPepperoni().addMushrooms();
custom.build().describe();


// ==================== EJEMPLO PRÁCTICO: HTTP REQUEST ====================

class HttpRequest {
  constructor(
    public url: string = '',
    public method: string = 'GET',
    public headers: Map<string, string> = new Map(),
    public body: any = null,
    public timeout: number = 30000
  ) {}

  toCurl(): string {
    let curl = `curl -X ${this.method} '${this.url}'`;
    this.headers.forEach((value, key) => {
      curl += ` -H '${key}: ${value}'`;
    });
    if (this.body) {
      curl += ` -d '${JSON.stringify(this.body)}'`;
    }
    return curl;
  }
}

class HttpRequestBuilder {
  private request: HttpRequest;

  constructor() {
    this.request = new HttpRequest();
  }

  url(url: string): HttpRequestBuilder {
    this.request.url = url;
    return this;
  }

  method(method: string): HttpRequestBuilder {
    this.request.method = method;
    return this;
  }

  header(key: string, value: string): HttpRequestBuilder {
    this.request.headers.set(key, value);
    return this;
  }

  auth(token: string): HttpRequestBuilder {
    this.request.headers.set('Authorization', `Bearer ${token}`);
    return this;
  }

  jsonBody(body: object): HttpRequestBuilder {
    this.request.body = body;
    this.request.headers.set('Content-Type', 'application/json');
    return this;
  }

  timeout(ms: number): HttpRequestBuilder {
    this.request.timeout = ms;
    return this;
  }

  build(): HttpRequest {
    const result = this.request;
    this.request = new HttpRequest();
    return result;
  }
}

const request = new HttpRequestBuilder()
  .url('https://api.example.com/users')
  .method('POST')
  .auth('token123')
  .jsonBody({ name: 'Alice', email: 'alice@example.com' })
  .timeout(5000)
  .build();

console.log(request.toCurl());
```

### Cuándo Usarlo

- Objetos con muchos parámetros opcionales
- Construcción paso a paso de objetos complejos
- Cuando el proceso de construcción debe crear diferentes representaciones

### Ventajas

- Construcción paso a paso
- Reutilización de código de construcción
- SRP - aislar código de construcción

### Desventajas

- Complejidad adicional
- Puede ser overkill para objetos simples

---

## PATRONES ESTRUCTURALES

Los patrones estructurales se centran en cómo se componen los objetos para formar estructuras más grandes.

---

## 5. Adapter

### Definición

Convierte la interfaz de una clase en otra interfaz que los clientes esperan. Permite que clases con interfaces incompatibles trabajen juntas.

### Diagrama

```
    ┌──────────┐            ┌──────────┐
    │  Client  │───────────▶│  Target  │
    └──────────┘            │(Interface)
                            └────┬─────┘
                                 │
                          ┌──────▼──────┐
                          │   Adapter   │
                          ├─────────────┤
                          │ +request()  │
                          └──────┬──────┘
                                 │
                          ┌──────▼──────┐
                          │   Adaptee   │
                          │ (Existing)  │
                          └─────────────┘
```

### Ejemplo en TypeScript

```typescript
// ==================== INTERFAZ OBJETIVO ====================

interface PaymentProcessor {
  processPayment(amount: number, currency: string): Promise<PaymentResult>;
  refundPayment(transactionId: string): Promise<RefundResult>;
}

interface PaymentResult {
  success: boolean;
  transactionId: string;
  message?: string;
}

interface RefundResult {
  success: boolean;
  refundId: string;
  message?: string;
}

// ==================== ADAPTEE (Sistema externo) ====================

class StripeAPI {
  private apiKey: string;

  constructor(apiKey: string) {
    this.apiKey = apiKey;
  }

  async charge(cardToken: string, amountInCents: number, currency: string): Promise<any> {
    console.log(`[Stripe] Charging ${amountInCents} ${currency} with token ${cardToken}`);
    return {
      id: `stripe_${crypto.randomUUID()}`,
      status: 'succeeded',
      amount: amountInCents,
      currency
    };
  }

  async refunds(chargeId: string): Promise<any> {
    console.log(`[Stripe] Refunding charge ${chargeId}`);
    return {
      id: `refund_${crypto.randomUUID()}`,
      status: 'succeeded',
      charge: chargeId
    };
  }
}

class PayPalAPI {
  private clientId: string;

  constructor(clientId: string) {
    this.clientId = clientId;
  }

  async makePayment(email: string, amount: number, currency: string): Promise<any> {
    console.log(`[PayPal] Payment of ${amount} ${currency} from ${email}`);
    return {
      transactionId: `pp_${crypto.randomUUID()}`,
      state: 'completed',
      amount: { total: amount, currency }
    };
  }

  async refundTransaction(transactionId: string): Promise<any> {
    console.log(`[PayPal] Refunding transaction ${transactionId}`);
    return {
      refundId: `ppr_${crypto.randomUUID()}`,
      state: 'completed'
    };
  }
}

// ==================== ADAPTERS ====================

class StripeAdapter implements PaymentProcessor {
  constructor(private stripeAPI: StripeAPI) {}

  async processPayment(amount: number, currency: string): Promise<PaymentResult> {
    const amountInCents = Math.round(amount * 100);
    const result = await this.stripeAPI.charge('tok_visa', amountInCents, currency);
    
    return {
      success: result.status === 'succeeded',
      transactionId: result.id,
      message: result.status
    };
  }

  async refundPayment(transactionId: string): Promise<RefundResult> {
    const result = await this.stripeAPI.refunds(transactionId);
    
    return {
      success: result.status === 'succeeded',
      refundId: result.id
    };
  }
}

class PayPalAdapter implements PaymentProcessor {
  constructor(private paypalAPI: PayPalAPI) {}

  async processPayment(amount: number, currency: string): Promise<PaymentResult> {
    const result = await this.paypalAPI.makePayment('user@example.com', amount, currency);
    
    return {
      success: result.state === 'completed',
      transactionId: result.transactionId,
      message: result.state
    };
  }

  async refundPayment(transactionId: string): Promise<RefundResult> {
    const result = await this.paypalAPI.refundTransaction(transactionId);
    
    return {
      success: result.state === 'completed',
      refundId: result.refundId
    };
  }
}

// ==================== CLIENTE ====================

class CheckoutService {
  constructor(private paymentProcessor: PaymentProcessor) {}

  async checkout(total: number, currency: string = 'USD'): Promise<void> {
    const result = await this.paymentProcessor.processPayment(total, currency);
    
    if (result.success) {
      console.log(`✅ Payment successful: ${result.transactionId}`);
    } else {
      console.log(`❌ Payment failed: ${result.message}`);
    }
  }

  async processRefund(transactionId: string): Promise<void> {
    const result = await this.paymentProcessor.refundPayment(transactionId);
    
    if (result.success) {
      console.log(`✅ Refund successful: ${result.refundId}`);
    } else {
      console.log(`❌ Refund failed`);
    }
  }
}

// Uso
console.log('--- Stripe Payment ---');
const stripeAdapter = new StripeAdapter(new StripeAPI('sk_test_123'));
const checkout1 = new CheckoutService(stripeAdapter);
await checkout1.checkout(99.99);

console.log('\n--- PayPal Payment ---');
const paypalAdapter = new PayPalAdapter(new PayPalAPI('client_456'));
const checkout2 = new CheckoutService(paypalAdapter);
await checkout2.checkout(149.99);

await checkout2.processRefund('pp_abc123');


// ==================== ADAPTER DE TERCEROS (LIBRERÍA EXTERNA) ====================

class ExternalLegacySystem {
  process(data: string): string {
    return `[Legacy] Processed: ${data}`;
  }
}

interface ModernInterface {
  processObject(obj: object): object;
}

class LegacyAdapter implements ModernInterface {
  private legacySystem: ExternalLegacySystem;

  constructor() {
    this.legacySystem = new ExternalLegacySystem();
  }

  processObject(obj: object): object {
    const jsonString = JSON.stringify(obj);
    const result = this.legacySystem.process(jsonString);
    return { result };
  }
}

const adapter = new LegacyAdapter();
console.log(adapter.processObject({ key: 'value' }));
```

### Cuándo Usarlo

- Integración con sistemas legacy
- Uso de librerías externas
- Normalización de interfaces

### Ventajas

- Desacoplamiento
- Reutilización de código existente
- Flexibilidad

### Desventajas

- Complejidad adicional
- Puede ocultar problemas de diseño

---

## 6. Decorator

### Definición

Agrega responsabilidades adicionales a un objeto dinámicamente. Alternativa a la herencia para extender funcionalidad.

### Diagrama

```
         ┌───────────────────────┐
         │    Component          │
         │   (Interface)         │
         ├───────────────────────┤
         │ + operation(): void   │
         └───────────┬───────────┘
                     │
        ┌────────────┴────────────┐
        ▼                         ▼
┌───────────────┐        ┌────────────────┐
│   Concrete   │        │    Decorator   │
│  Component    │        │  (Abstract)    │
├───────────────┤        ├────────────────┤
│ + operation() │        │ - component    │
└───────────────┘        │ + operation()  │
                         └───────┬────────┘
                                 │
              ┌──────────────────┼──────────────────┐
              ▼                  ▼                  ▼
       ┌───────────┐     ┌────────────┐     ┌────────────┐
       │DecoratorA │     │ DecoratorB │     │ DecoratorC │
       ├───────────┤     ├────────────┤     ├────────────┤
       │+operation │     │ +operation  │     │ +operation  │
       └───────────┘     └────────────┘     └────────────┘
```

### Ejemplo en TypeScript

```typescript
// ==================== COMPONENTE BASE ====================

interface Coffee {
  getCost(): number;
  getDescription(): string;
}

class SimpleCoffee implements Coffee {
  getCost(): number {
    return 5;
  }

  getDescription(): string {
    return 'Simple coffee';
  }
}

// ==================== DECORATOR BASE ====================

abstract class CoffeeDecorator implements Coffee {
  protected coffee: Coffee;

  constructor(coffee: Coffee) {
    this.coffee = coffee;
  }

  abstract getCost(): number;
  abstract getDescription(): string;
}

// ==================== DECORATORS CONCRETOS ====================

class MilkDecorator extends CoffeeDecorator {
  getCost(): number {
    return this.coffee.getCost() + 1.5;
  }

  getDescription(): string {
    return this.coffee.getDescription() + ', milk';
  }
}

class SugarDecorator extends CoffeeDecorator {
  getCost(): number {
    return this.coffee.getCost() + 0.5;
  }

  getDescription(): string {
    return this.coffee.getDescription() + ', sugar';
  }
}

class WhipDecorator extends CoffeeDecorator {
  getCost(): number {
    return this.coffee.getCost() + 2;
  }

  getDescription(): string {
    return this.coffee.getDescription() + ', whipped cream';
  }
}

class CaramelDecorator extends CoffeeDecorator {
  getCost(): number {
    return this.coffee.getCost() + 1;
  }

  getDescription(): string {
    return this.coffee.getDescription() + ', caramel';
  }
}

// ==================== USO ====================

console.log('--- Coffee Orders ---');

let coffee = new SimpleCoffee();
console.log(`${coffee.getDescription()}: $${coffee.getCost()}`);

coffee = new MilkDecorator(coffee);
console.log(`${coffee.getDescription()}: $${coffee.getCost()}`);

coffee = new WhipDecorator(coffee);
console.log(`${coffee.getDescription()}: $${coffee.getCost()}`);

coffee = new CaramelDecorator(coffee);
console.log(`${coffee.getDescription()}: $${coffee.getCost()}`);

console.log('\n--- Another Order ---');
const coffee2 = new CaramelDecorator(
  new MilkDecorator(
    new SugarDecorator(
      new SimpleCoffee()
    )
  )
);
console.log(`${coffee2.getDescription()}: $${coffee2.getCost()}`);


// ==================== EJEMPLO PRÁCTICO: HTTP CLIENT ====================

interface HttpClient {
  get(url: string): Promise<Response>;
  post(url: string, data: any): Promise<Response>;
}

class FetchClient implements HttpClient {
  async get(url: string): Promise<Response> {
    console.log(`[GET] ${url}`);
    return fetch(url);
  }

  async post(url: string, data: any): Promise<Response> {
    console.log(`[POST] ${url}`);
    return fetch(url, { method: 'POST', body: JSON.stringify(data) });
  }
}

abstract class HttpClientDecorator implements HttpClient {
  constructor(protected client: HttpClient) {}

  abstract get(url: string): Promise<Response>;
  abstract post(url: string, data: any): Promise<Response>;
}

class LoggingDecorator extends HttpClientDecorator {
  async get(url: string): Promise<Response> {
    console.log(`[LOG] GET request to ${url}`);
    const start = Date.now();
    const response = await this.client.get(url);
    console.log(`[LOG] Response time: ${Date.now() - start}ms`);
    return response;
  }

  async post(url: string, data: any): Promise<Response> {
    console.log(`[LOG] POST request to ${url}`);
    const start = Date.now();
    const response = await this.client.post(url, data);
    console.log(`[LOG] Response time: ${Date.now() - start}ms`);
    return response;
  }
}

class AuthDecorator extends HttpClientDecorator {
  constructor(client: HttpClient, private token: string) {
    super(client);
  }

  async get(url: string): Promise<Response> {
    return this.client.get(url);
  }

  async post(url: string, data: any): Promise<Response> {
    return this.client.post(url, data);
  }
}

class CacheDecorator extends HttpClientDecorator {
  private cache: Map<string, { data: any; expiry: number }> = new Map();

  async get(url: string): Promise<Response> {
    const cached = this.cache.get(url);
    if (cached && cached.expiry > Date.now()) {
      console.log(`[CACHE] Returning cached response for ${url}`);
      return new Response(JSON.stringify(cached.data));
    }
    
    const response = await this.client.get(url);
    const data = await response.json();
    
    this.cache.set(url, {
      data,
      expiry: Date.now() + 60000
    });
    
    return response;
  }

  async post(url: string, data: any): Promise<Response> {
    this.cache.clear();
    return this.client.post(url, data);
  }
}

// Uso
const client = new LoggingDecorator(
  new CacheDecorator(
    new FetchClient()
  )
);

client.get('https://api.example.com/data');
```

### Cuándo Usarlo

- Agregar responsabilidades dinámicamente
- Evitar herencia múltiple
- Responsabilidades que pueden ser removidas

### Ventajas

- Más flexible que herencia
- Agregar/remover responsabilidades en runtime
- Composición flexible

### Desventajas

- Puede crear muchos objetos pequeños
- Difícil de debuggear si hay muchos decoradores

---

## PATRONES DE COMPORTAMIENTO

Los patrones de comportamiento se centran en la comunicación entre objetos y la distribución de responsabilidades.

---

## 7. Observer

### Definición

Define una dependencia uno-a-muchos entre objetos, de modo que cuando un objeto cambia de estado, todos sus dependientes son notificados.

### Diagrama

```
┌────────────────────┐           ┌────────────────────┐
│    Subject         │           │     Observer       │
├────────────────────┤           ├────────────────────┤
│ + attach(obs)      │──────────▶│ + update()         │
│ + detach(obs)      │           └────────────────────┘
│ + notify()         │
└────────┬───────────┘
         │
         │ contains
         ▼
┌────────────────────┐     ┌────────────────────┐
│  ConcreteSubject  │     │ ConcreteObserverA  │
├────────────────────┤     ├────────────────────┤
│ + setState()       │────▶│ + update()         │
│ + getState()       │     └────────────────────┘
└────────────────────┘
```

### Ejemplo en TypeScript

```typescript
// ==================== OBSERVER INTERFACE ====================

interface Observer {
  update(data: any): void;
}

interface Subject {
  attach(observer: Observer): void;
  detach(observer: Observer): void;
  notify(): void;
}

// ==================== CONCRETE SUBJECT ====================

class NewsAgency implements Subject {
  private observers: Observer[] = [];
  private latestNews: string = '';

  attach(observer: Observer): void {
    this.observers.push(observer);
    console.log(`[NewsAgency] Observer attached`);
  }

  detach(observer: Observer): void {
    const index = this.observers.indexOf(observer);
    if (index > -1) {
      this.observers.splice(index, 1);
      console.log(`[NewsAgency] Observer detached`);
    }
  }

  notify(): void {
    console.log(`[NewsAgency] Notifying ${this.observers.length} observers`);
    this.observers.forEach(observer => observer.update(this.latestNews));
  }

  publishNews(news: string): void {
    console.log(`\n[NewsAgency] Breaking News: ${news}`);
    this.latestNews = news;
    this.notify();
  }
}

// ==================== CONCRETE OBSERVERS ====================

class NewsChannel implements Observer {
  constructor(private name: string) {}

  update(news: string): void {
    console.log(`[${this.name}] Broadcasting: ${news}`);
  }
}

class NewsSubscriber implements Observer {
  constructor(private email: string) {}

  update(news: string): void {
    console.log(`[Email to ${this.email}] You have new news: ${news}`);
  }
}

class NewsAnalytics implements Observer {
  private newsCount = 0;
  private totalLength = 0;

  update(news: string): void {
    this.newsCount++;
    this.totalLength += news.length;
    console.log(`[Analytics] News #${this.newsCount}, Avg length: ${this.totalLength / this.newsCount}`);
  }
}

// Uso
console.log('=== News Agency Demo ===');

const agency = new NewsAgency();

const cnn = new NewsChannel('CNN');
const bbc = new NewsChannel('BBC');
const subscriber = new NewsSubscriber('user@example.com');
const analytics = new NewsAnalytics();

agency.attach(cnn);
agency.attach(bbc);
agency.attach(subscriber);
agency.attach(analytics);

agency.publishNews('Breaking: TypeScript 5.0 released!');

agency.detach(bbc);

agency.publishNews('Update: New features in TypeScript 5.0');


// ==================== IMPLEMENTACIÓN CON EVENT EMITTER ====================

type EventHandler = (...args: any[]) => void;

class EventEmitter {
  private events: Map<string, EventHandler[]> = new Map();

  on(event: string, handler: EventHandler): void {
    if (!this.events.has(event)) {
      this.events.set(event, []);
    }
    this.events.get(event)!.push(handler);
  }

  off(event: string, handler: EventHandler): void {
    const handlers = this.events.get(event);
    if (handlers) {
      const index = handlers.indexOf(handler);
      if (index > -1) handlers.splice(index, 1);
    }
  }

  emit(event: string, ...args: any[]): void {
    const handlers = this.events.get(event);
    if (handlers) {
      handlers.forEach(handler => handler(...args));
    }
  }

  once(event: string, handler: EventHandler): void {
    const onceHandler: EventHandler = (...args: any[]) => {
      handler(...args);
      this.off(event, onceHandler);
    };
    this.on(event, onceHandler);
  }
}

// Uso del EventEmitter
console.log('\n=== EventEmitter Demo ===');

const emitter = new EventEmitter();

emitter.on('user:created', (user: any) => {
  console.log(`[User Service] New user created: ${user.name}`);
});

emitter.on('user:created', (user: any) => {
  console.log(`[Email Service] Welcome email sent to ${user.email}`);
});

emitter.emit('user:created', { name: 'Alice', email: 'alice@example.com' });

emitter.once('app:started', () => {
  console.log('[App] Started event - only fires once');
});

emitter.emit('app:started');
emitter.emit('app:started');
```

### Cuándo Usarlo

- Interfaz gráfica con múltiples vistas
- Sistemas de notificaciones
- Event-driven architectures
- Suscripciones en general

### Ventajas

- Desacoplamiento
- Comunicación broadcast
- Dinámico

### Desventajas

- Memory leaks si no se limpian observers
- Orden de notificaciones no garantizado

---

## 8. Strategy

### Definición

Define una familia de algoritmos, encapsula cada uno, y los hace intercambiables. Permite variar el algoritmo independientemente de los clientes.

### Diagrama

```
┌─────────────────────┐         ┌─────────────────────┐
│       Context      │─────────▶│      Strategy       │
├─────────────────────┤         ├─────────────────────┤
│ + setStrategy()     │         │ + execute()         │
│ + executeStrategy()│         └──────────┬──────────┘
└─────────────────────┘                    │
                                              │
                      ┌───────────────────────┼───────────────────────┐
                      ▼                       ▼                       ▼
              ┌───────────────┐       ┌───────────────┐       ┌───────────────┐
              │ StrategyA     │       │ StrategyB     │       │ StrategyC    │
              ├───────────────┤       ├───────────────┤       ├───────────────┤
              │ + execute()   │       │ + execute()   │       │ + execute()   │
              └───────────────┘       └───────────────┘       └───────────────┘
```

### Ejemplo en TypeScript

```typescript
// ==================== ESTRATEGIA INTERFACE ====================

interface PaymentStrategy {
  pay(amount: number): Promise<PaymentResult>;
}

interface PaymentResult {
  success: boolean;
  transactionId?: string;
  message?: string;
}

// ==================== ESTRATEGIAS CONCRETAS ====================

class CreditCardPayment implements PaymentStrategy {
  constructor(private cardNumber: string, private cvv: string) {}

  async pay(amount: number): Promise<PaymentResult> {
    console.log(`[CreditCard] Processing $${amount} for card ending in ${this.cardNumber.slice(-4)}`);
    
    if (amount > 10000) {
      return { success: false, message: 'Amount exceeds limit' };
    }

    return {
      success: true,
      transactionId: `cc_${crypto.randomUUID()}`,
      message: 'Payment approved'
    };
  }
}

class PayPalPayment implements PaymentStrategy {
  constructor(private email: string) {}

  async pay(amount: number): Promise<PaymentResult> {
    console.log(`[PayPal] Processing $${amount} for account ${this.email}`);
    
    return {
      success: true,
      transactionId: `pp_${crypto.randomUUID()}`,
      message: 'Payment successful'
    };
  }
}

class CryptoPayment implements PaymentStrategy {
  constructor(private walletAddress: string) {}

  async pay(amount: number): Promise<PaymentResult> {
    console.log(`[Crypto] Processing $${amount} for wallet ${this.walletAddress.slice(0, 8)}...`);
    
    return {
      success: true,
      transactionId: `crypto_${crypto.randomUUID()}`,
      message: 'Blockchain transaction confirmed'
    };
  }
}

class BankTransferPayment implements PaymentStrategy {
  constructor(private accountNumber: string) {}

  async pay(amount: number): Promise<PaymentResult> {
    console.log(`[Bank] Processing $${amount} for account ${this.accountNumber}`);
    
    return {
      success: true,
      transactionId: `bank_${crypto.randomUUID()}`,
      message: 'Transfer initiated'
    };
  }
}

// ==================== CONTEXTO ====================

class ShoppingCart {
  private items: Array<{ name: string; price: number }> = [];
  private paymentStrategy?: PaymentStrategy;

  addItem(name: string, price: number): void {
    this.items.push({ name, price });
    console.log(`Added: ${name} - $${price}`);
  }

  removeItem(name: string): void {
    const index = this.items.findIndex(i => i.name === name);
    if (index > -1) {
      this.items.splice(index, 1);
      console.log(`Removed: ${name}`);
    }
  }

  setPaymentStrategy(strategy: PaymentStrategy): void {
    this.paymentStrategy = strategy;
    console.log(`Payment strategy set`);
  }

  getTotal(): number {
    return this.items.reduce((sum, item) => sum + item.price, 0);
  }

  async checkout(): Promise<void> {
    if (!this.paymentStrategy) {
      console.log('Please select a payment method');
      return;
    }

    const total = this.getTotal();
    console.log(`\nTotal: $${total}`);
    
    const result = await this.paymentStrategy.pay(total);
    
    if (result.success) {
      console.log(`✅ Checkout successful! Transaction: ${result.transactionId}`);
      this.items = [];
    } else {
      console.log(`❌ Checkout failed: ${result.message}`);
    }
  }
}

// Uso
console.log('=== Shopping Cart with Strategies ===\n');

const cart = new ShoppingCart();

cart.addItem('Laptop', 999.99);
cart.addItem('Mouse', 29.99);
cart.addItem('Keyboard', 79.99);

cart.setPaymentStrategy(new CreditCardPayment('4111111111111111', '123'));
await cart.checkout();

console.log('\n--- Changing payment method ---\n');

cart.addItem('Headphones', 199.99);

cart.setPaymentStrategy(new PayPalPayment('user@example.com'));
await cart.checkout();

console.log('\n--- Using Crypto ---\n');

cart.setPaymentStrategy(new CryptoPayment('0x742d35Cc6634C0532925a3b844Bc9e7595f'));
await cart.checkout();


// ==================== OTRO EJEMPLO: VALIDACIÓN ====================

interface Validator {
  validate(value: any): boolean;
  getError(): string;
}

class EmailValidator implements Validator {
  private error = '';

  validate(value: any): boolean {
    const isValid = /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(value);
    this.error = isValid ? '' : 'Invalid email format';
    return isValid;
  }

  getError(): string {
    return this.error;
  }
}

class PasswordValidator implements Validator {
  validate(value: any): boolean {
    const isValid = value.length >= 8 && /[A-Z]/.test(value) && /[0-9]/.test(value);
    this.error = isValid ? '' : 'Password must be 8+ chars with uppercase and number';
    return isValid;
  }

  getError(): string {
    return this.error;
  }
}

class FormField {
  constructor(
    private value: any,
    private validators: Validator[]
  ) {}

  validate(): boolean {
    return this.validators.every(v => v.validate(this.value));
  }

  getErrors(): string[] {
    return this.validators.map(v => v.getError()).filter(e => e);
  }
}

console.log('\n=== Form Validation ===');
const emailField = new FormField('test@example.com', [new EmailValidator()]);
console.log(`Email valid: ${emailField.validate()}`);

const invalidEmail = new FormField('invalid', [new EmailValidator()]);
console.log(`Invalid email valid: ${invalidEmail.validate()}`);
console.log(`Errors: ${invalidEmail.getErrors()}`);
```

### Cuándo Usarlo

- Múltiples algoritmos para una tarea
- Necesidad de cambiar comportamiento en runtime
- Evitar condicionales complejas

### Ventajas

- Algoritmos intercambiables
- Desacoplamiento
- Testing fácil

### Desventajas

- Más objetos
- Cliente debe conocer las estrategias

---

## 9. Repository

### Definición

Abstrae la capa de acceso a datos, proporcionando una colección-like interface para acceder a objetos de dominio.

### Diagrama

```
┌──────────────┐         ┌─────────────────┐         ┌──────────────┐
│    Client    │────────▶│   Repository   │────────▶│  Data Store │
│              │         │  (Interface)   │         │  (SQL/NoSQL)│
└──────────────┘         └────────┬────────┘         └──────────────┘
                                 │
                    ┌────────────┼────────────┐
                    ▼                         ▼
           ┌───────────────┐         ┌───────────────┐
           │ConcreteRepoSQL│         │ConcreteRepoMongo│
           └───────────────┘         └───────────────┘
```

### Ejemplo en TypeScript

```typescript
// ==================== ENTIDAD ====================

interface Entity {
  id: string;
}

interface User extends Entity {
  name: string;
  email: string;
  age: number;
  createdAt: Date;
}

// ==================== REPOSITORY INTERFACE ====================

interface Repository<T extends Entity> {
  findAll(): Promise<T[]>;
  findById(id: string): Promise<T | null>;
  findBy(predicate: (item: T) => boolean): Promise<T[]>;
  save(entity: T): Promise<T>;
  delete(id: string): Promise<void>;
  count(): Promise<number>;
}

// ==================== CONCRETE REPOSITORIES ====================

class InMemoryUserRepository implements Repository<User> {
  private users: Map<string, User> = new Map();

  async findAll(): Promise<User[]> {
    return Array.from(this.users.values());
  }

  async findById(id: string): Promise<User | null> {
    return this.users.get(id) || null;
  }

  async findBy(predicate: (item: User) => boolean): Promise<User[]> {
    return Array.from(this.users.values()).filter(predicate);
  }

  async save(entity: User): Promise<User> {
    this.users.set(entity.id, entity);
    return entity;
  }

  async delete(id: string): Promise<void> {
    this.users.delete(id);
  }

  async count(): Promise<number> {
    return this.users.size;
  }
}

class FileUserRepository implements Repository<User> {
  private filePath: string;

  constructor(filePath: string) {
    this.filePath = filePath;
  }

  private async readFile(): Promise<User[]> {
    try {
      const data = await Bun.file(this.filePath).text();
      return data ? JSON.parse(data) : [];
    } catch {
      return [];
    }
  }

  private async writeFile(users: User[]): Promise<void> {
    await Bun.write(this.filePath, JSON.stringify(users, null, 2));
  }

  async findAll(): Promise<User[]> {
    return this.readFile();
  }

  async findById(id: string): Promise<User | null> {
    const users = await this.readFile();
    return users.find(u => u.id === id) || null;
  }

  async findBy(predicate: (item: User) => boolean): Promise<User[]> {
    const users = await this.readFile();
    return users.filter(predicate);
  }

  async save(entity: User): Promise<User> {
    const users = await this.readFile();
    const index = users.findIndex(u => u.id === entity.id);
    
    if (index >= 0) {
      users[index] = entity;
    } else {
      users.push(entity);
    }
    
    await this.writeFile(users);
    return entity;
  }

  async delete(id: string): Promise<void> {
    const users = await this.readFile();
    const filtered = users.filter(u => u.id !== id);
    await this.writeFile(filtered);
  }

  async count(): Promise<number> {
    const users = await this.readFile();
    return users.length;
  }
}

// ==================== EJEMPLO DE USO ====================

async function main() {
  console.log('=== Repository Pattern Demo ===\n');

  const repo = new InMemoryUserRepository();

  const user1: User = {
    id: crypto.randomUUID(),
    name: 'Alice',
    email: 'alice@example.com',
    age: 30,
    createdAt: new Date()
  };

  const user2: User = {
    id: crypto.randomUUID(),
    name: 'Bob',
    email: 'bob@example.com',
    age: 25,
    createdAt: new Date()
  };

  const user3: User = {
    id: crypto.randomUUID(),
    name: 'Charlie',
    email: 'charlie@example.com',
    age: 35,
    createdAt: new Date()
  };

  await repo.save(user1);
  await repo.save(user2);
  await repo.save(user3);

  console.log(`Total users: ${await repo.count()}`);

  const alice = await repo.findById(user1.id);
  console.log(`Found user: ${alice?.name}`);

  const adults = await repo.findBy(u => u.age >= 30);
  console.log(`Users 30+: ${adults.map(u => u.name).join(', ')}`);

  await repo.delete(user2.id);
  console.log(`After delete: ${await repo.count()} users`);

  const all = await repo.findAll();
  console.log(`All users: ${all.map(u => u.name).join(', ')}`);
}

main();
```

### Cuándo Usarlo

- Abstraer acceso a datos
- Testing (mocking fácil)
- Cambiar de storage sin cambiar código

### Ventajas

- Desacoplamiento
- Testing fácil
- Централизованный acceso a datos

### Desventajas

- Complejidad adicional
- Puede ser overkill simple CRUD

---

## 10. Dependency Injection

### Definición

Patrón donde los objetos reciben sus dependencias desde外部 en lugar de crearlos internamente. Implementación de Inversión de Control (IoC).

### Diagrama

```
┌─────────────────────┐         ┌─────────────────────┐
│    Client          │────────▶│    Service          │
│    (Consumer)      │         │    (Dependency)     │
└─────────────────────┘         └─────────────────────┘
                                    ▲
                                    │
                           ┌────────┴────────┐
                           │                │
                    ┌──────▼──────┐  ┌──────▼──────┐
                    │ Injector    │  │  Container  │
                    │ (DI Frame)  │  │  (IoC)      │
                    └─────────────┘  └─────────────┘
```

### Ejemplo en TypeScript

```typescript
// ==================== SERVICIOS ====================

interface Logger {
  log(message: string): void;
}

class ConsoleLogger implements Logger {
  log(message: string): void {
    console.log(`[LOG] ${message}`);
  }
}

class FileLogger implements Logger {
  constructor(private filename: string) {}

  log(message: string): void {
    console.log(`[FILE:${this.filename}] ${message}`);
  }
}

// ==================== SERVICIO CON DEPENDENCIAS ====================

interface UserRepository {
  findById(id: string): Promise<any>;
}

class InMemoryUserRepository implements UserRepository {
  private users = new Map();

  async findById(id: string): Promise<any> {
    return this.users.get(id);
  }
}

class UserService {
  constructor(
    private userRepository: UserRepository,
    private logger: Logger
  ) {}

  async getUser(id: string): Promise<any> {
    this.logger.log(`Fetching user ${id}`);
    const user = await this.userRepository.findById(id);
    if (!user) {
      this.logger.log(`User ${id} not found`);
    }
    return user;
  }
}

// ==================== INJECTOR MANUAL ====================

function createUserService(): UserService {
  const logger = new ConsoleLogger();
  const userRepo = new InMemoryUserRepository();
  
  return new UserService(userRepo, logger);
}

const service1 = createUserService();


// ==================== CONTAINER DI SIMPLE ====================

type Constructor<T = any> = new (...args: any[]) => T;

interface Binding<T> {
  useClass: Constructor<T>;
  instance?: T;
}

class DIContainer {
  private bindings: Map<string, Binding<any>> = new Map();
  private singletons: Map<string, any> = new Map();

  register<T>(token: string, useClass: Constructor<T>): void {
    this.bindings.set(token, { useClass });
  }

  registerSingleton<T>(token: string, useClass: Constructor<T>): void {
    this.bindings.set(token, { useClass, instance: null });
  }

  resolve<T>(token: string): T {
    const binding = this.bindings.get(token);
    if (!binding) {
      throw new Error(`No binding found for ${token}`);
    }

    if (binding.instance) {
      return binding.instance;
    }

    const instance = new binding.useClass();
    return instance;
  }

  resolveWithDeps<T>(token: string): T {
    const binding = this.bindings.get(token);
    if (!binding) {
      throw new Error(`No binding found for ${token}`);
    }

    if (binding.instance) {
      return binding.instance;
    }

    const instance = this.createInstance(binding.useClass);
    
    if (binding.instance === undefined) {
      binding.instance = instance;
    }
    
    return instance;
  }

  private createInstance<T>(Constructor: Constructor<T>): T {
    const params = Reflect.getMetadata('design:paramtypes', Constructor) || [];
    const deps = params.map((param: any) => this.resolveWithDeps(param));
    return new Constructor(...deps);
  }
}

// Uso del Container
const container = new DIContainer();

container.register<Logger>('Logger', ConsoleLogger);
container.register<UserRepository>('UserRepository', InMemoryUserRepository);
container.register<UserService>('UserService', UserService);

const userService = container.resolveWithDeps<UserService>('UserService');
console.log(userService);


// ==================== CON DECORADORES ====================

const TYPES = {
  Logger: 'Logger',
  UserRepository: 'UserRepository',
  UserService: 'UserService'
};

function injectable(target: any): void {
  // Metadata se maneja automáticamente en frameworks reales
}

function inject(token: string) {
  return function (target: any, propertyKey: string, parameterIndex: number) {
    // Metadata para inyección
  };
}

@injectable()
class OrderService {
  constructor(
    @inject(TYPES.Logger) private logger: Logger,
    @inject('OrderRepository') private orderRepo: any
  ) {}

  processOrder(orderId: string): void {
    this.logger.log(`Processing order ${orderId}`);
  }
}
```

### Cuándo Usarlo

- Testing
- Aplicaciones modulares
- Frameworks empresariales

### Ventajas

- Testing fácil (mocks)
- Desacoplamiento
- Flexibilidad
- SRP

### Desventajas

- Complejidad
- Curva de aprendizaje

---

## Resumen de Patrones

| Patrón | Tipo | Propósito |
|--------|------|-----------|
| **Singleton** | Creacional | Una sola instancia global |
| **Factory Method** | Creacional | Crear objetos sin especificar clase |
| **Abstract Factory** | Creacional | Familia de objetos relacionados |
| **Builder** | Creacional | Construcción paso a paso |
| **Adapter** | Estructural | Interfaz incompatible → compatible |
| **Decorator** | Estructural | Agregar responsabilidades dinámicamente |
| **Observer** | Comportamiento | Notificación de cambios |
| **Strategy** | Comportamiento | Algoritmos intercambiables |
| **Repository** | Acceso a datos | Abstracción de persistencia |
| **Dependency Injection** | Inversión de control | Inyección de dependencias |

---

## Recomendaciones

1. **No sobreingenierices**: Usa patrones solo cuando resuelvan un problema real
2. **Conoce tu herramienta**: Frameworks como Angular tienen DI incorporado
3. **Prioriza composición sobre herencia**: Adapter, Decorator > Herencia
4. **Testing**: Repository y DI facilitan el testing drásticamente
5. **Observa antes de aplicar**: Identifica el problema, luego busca el patrón

---

## Recursos Adicionales

- **Libro base**: "Design Patterns: Elements of Reusable Object-Oriented Software" (GoF)
- **TypeScript**: Los patrones se adaptan muy bien gracias al sistema de tipos
- **Frameworks**: NestJS implementa muchos de estos patrones nativamente

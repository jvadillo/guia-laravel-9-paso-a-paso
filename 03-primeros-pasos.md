# Tu primera aplicación en 8 pasos
Ahora que ya tenemos nuestro entorno de desarrollo preparado, crearemos una aplicación web con Laravel paso por paso. Al finalizar los 8 pasos que encontrarás en este capítulo, obtendremos como resultado una revista online a la que hemos llamado RevistApp. Esta aplicación mostrará los artículos de una revista almacenados en una base de datos. ¿Comenzamos ya?

## Paso 1 - Crea tu primer proyecto
Este paso **no es necesario realizarlo si has optado por utilizar Laravel Sail**, ya que Sail creará automáticamente una nueva aplicación junto con el entorno.

Si has decidido utilizar Laravel Homestead o Vagrant como tu entorno de desarrollo, entonces deberás realizar las siguientes acciones:

#### Crea la aplicación dentro de la máquina virtual
Accede a tu máquina virtual utilizando el comando `vagrant ssh` y posicionate en la carpeta donde almacenarás tus proyectos (la carpeta que has indicado en el archivo de configuración `Homestead.yaml`, por ejemplo: `/home/vagrant/proyects`). Ejecuta el siguiente comando para crear un nuevo proyecto:

```
composer create-project laravel/laravel revistapp
```

Si recibes un error, probablemente sea porque todavía no tienes Composer instalado en tu máquina virtual. Para ello, ejecuta el siguiente comando:

```
composer global require laravel/installer
```

Una vez instalado vuelve a ejecutar el comando `create-project` de Composer. Este comando inicializará un nuevo proyecto creando en el directorio `revistapp`. Puedes acceder a la aplicación entrando a http://aplicacion1.test (o el dominio que hayas indicado en la configuración) desde tu navegador favorito.

De forma alternativa también puedes utilizar el comando `laravel new` que también creará un nuevo proyecto de Laravel en la carpeta especificada:

```
laravel new revistapp
```

Puedes entrar a la nueva carpeta del proyecto creada, `revistapp`, para ver los archivos que se han generada. A partir de ahora siempre trabajaremos dentro de este directorio. 

Ten en cuenta que en este caso, al haber creado una aplicación llamada `revistapp`, deberás tener una entrada en tu archivo de configuración `Homestead.yaml` que referencia a la carpeta `/public` del proyecto recién creado:

```yaml
sites:
    - map: articulos.test
      to: /home/vagrant/code/revistapp/public
```

#### Generar la clave de la aplicación (Application Key)
Laravel utiliza una clave para securizar tu aplicación. La clave de aplicación es un string de 32 caracteres utilizado para encriptar datos como la sesión de usuario. Cuando se instala Laravel utilizando Composer o el instalador de Laravel, la clave se genera automáticamente, por lo que no es necesario hacer nada. Comprueba que existe un valor para `APP_KEY` en el fichero de configuración `.env`. En caso de no tener una clave generada, créala utilizando el siguiente comando:

```
php artisan key:generate
```

#### Establecer los permisos de directorio
Homestead realiza este paso por nosotros, por lo que si estás utilizando Homestead los permisos deberían estar correctamente establecidos. Si no estás utilizando Homestead o quieres desplegar tu aplicación en un servidor, no olvides establecer permisos de escritura para el servidor web en los directorios `storage` y  `bootstrap/cache`.

## Paso 2 - Crear un Router
Las rutas son los puntos de entrada a nuestra aplicación. Cada vez que un usuario hace una petición a una de las rutas de la aplicación, Laravel trata la petición mediante un Router definido en el directorio `routes`, el cual será el encargado de direccionar la petición a un Controlador. Las rutas accesibles para navegadores estarán definidas en el archivo `routes/web.php` y aquellas accesibles para servicios web (webservices) estarán definidas en el archivo `routes/api.php`. A continuación se muestra un ejemplo:

```php
Route::get('/articulos', function () {
    return '¡Vamos a leer unos articulos!';
});

```

El código anterior muestra cómo se define una ruta básica. En este caso, cuando el usuario realice una petición sobre `/articulos`, nuestra aplicación ejecutará la función anónima definida. En este caso enviará una respuesta al usuario con el string '¡Vamos a leer unos articulos!'.

Podemos especificar tantas rutas como queramos:

```php
Route::get('/articulos', function () {
    return '¡Vamos a leer unos articulos!';
});

Route::get('/usuarios', function () {
    return 'Hay muchos usuarios en esta aplicación';
});

```

También es posible responder a peticiones de tipo POST, por ejemplo para recibir datos de formularios: 

```php
Route::get('/articulos', function () {
    return '¡Vamos a leer unos articulos!';
});

Route::post('/articulos', function () {
    return '¡Vamos a insertar un artículo!';
});

```

Aparte de ejecutar las acciones definidas para cada ruta, Laravel ejecutará el middlewere específico en función del Router utilizado (por ejemplo, el middlewere relacionado con las peticiones web proveerá de funcionalidades como el estado de la sesión o la protección [CSRF](https://es.wikipedia.org/wiki/Cross-site_request_forgery)).

#### Ver las rutas creadas
La utilidad Artisan de Laravel nos provee de comandos muy útiles (por ejemplo, para crear controladores o migraciones). Disponemos de un comando concreto para mostrar todas las rutas de una aplicación de forma rápida. Basta con ejecutar el siguiente comando en la consola:

```
php artisan route:list
```
Recuerda que si estás utilizando Laravel Sail, puedes ejecutar el comando directamente los comandos de artisan incluyendo `sail` al princicio:

```
sail artisan route:list
```

Si quieres que Laravel no muestre las rutas creadas por paquetes de terceros (vendor) puedes añadir el flag `except-vendor` al final:
```
php artisan route:list --except-vendor
```

#### Devolver un JSON
También es posible devolver un JSON. Laravel convertirá automáticamente cualquier array a JSON:

```php
Route::get('/articulos', function () {
    return [
        "articulo 1" => "Primer artículo...",
        "articulo 2" => "Segundo artículo..."
    ];
});

```

#### Parámetros en la ruta
Una URL puede contener información de nuestro interés. Laravel permite acceder a esta información de forma sencilla utilizando los parámetros de ruta:

```php
Route::get('articulos/{id}', function ($id) {
    return 'Vas a leer el artículo: '.$id;
});
```

Los parámetros de ruta vienen definidos entre llaves `{}` y se inyectan automáticamente en las callbacks. Es posible utilizar más de un parámetro de ruta:

```php
Route::get('articulos/{id}/usuario/{name}', function ($id, $name) {
    return 'Vas a leer el artículo: '.$id. ' del usuario' .$name;
});
```

Para indicar un parámetro como opcional, le tenemos que añadir el símbolo `?` al final del parámentro. Le tendremos que añadir un valor por defecto para asegurarnos su correcto funcionamiento:

```php
Route::get('articulos/{id?}', function ($id = 0) {
    return 'Vas a leer el artículo: '.$id;
});
```


#### Acceder a la información de la petición
También es posible acceder a la información enviada en la petición. Por ejemplo, el siguiente código devolverá el valor enviado para el parámetro 'fecha' de la URL `/articulos?fecha=hoy`:

```php
Route::get('/articulos', function () {
    $fecha = request('fecha');
    return $fecha;
});
```

#### Rutas con nombre
Es posible asignar nombres a las rutas que sirvan para referirnos a ellas. De esta forma, en caso de que la URL de una ruta cambie, únicamente tendremos que cambiarlo en el mismo router y no en todos los ficheros HTML donde estemos enlazando a dicha ruta.

Para especificar el nombre a una ruta, simplemente debemos utilizar la función `name()`, la cual deberá recibir como parámetro el nombre que se desea asignar a la ruta:

```php
Route::get('/articulos', function () {
    return "Ruba con nombre!";
})->name('articulos');
```

En un futuro veremos cómo generar las URLs a partir de su nombre. Por ejemplo, en lugar de utilizar:

```html
<a href="/articulos">Ver artículos</a>
```

utilizaremos:

```html
<a href="{{ route('articulos') }}">Ver artículos</a>
```

## Paso 3 - Crear una vista

#### Definiendo una vista sencilla
Las vistas son plantillas que contienen el HTML que enviará nuestra aplicación a los usuarios. Se almacenan en el directorio `resources/views` de nuestro proyecto.

```html
<!-- vista almacenada en resources/views/articulos.blade.php -->
<html>
    <body>
        <h1>¡Vamos a leer unos artículos!</h1>
    </body>
</html>
```

Tendrán la extensión `.blade.php` ya que Laravel utiliza el motor de plantillas Blade, como veremos más adelante.

#### Devolver una vista
Cargar y devolver una vista al usuario es tan sencillo como utilizar la función global (helper) `view()`:

```php
Route::get('/articulos', function () {
    return view('articulos');
})->name('articulos');
```
No es necesario indicar la ruta completa de la vista ni la extensión `.blade.php`. Laravel asume que las vistas estarán en la carpeta `/resources/views` y tendrán la extensión `.blade.php`.

#### Acceder a datos desde la vista

Laravel utiliza el motor de plantillas [Blade](https://laravel.com/docs/9.x/blade) por defecto. Un motor de plantillas permite crear vistas empleando código HTML junto con código específico del motor empleado. De esta forma podremos mostrar información almacenada en variables, crear condiciones if/else, estructuras repetitivas, etc.

En Blade mostrar datos almacenados en variables es muy sencillo:

```html
<?php $nombre = "Nora"; ?>
<html>
    <body>
	<h1>Vamos a leer al escritor {{ $nombre }}</h1>
        </ul>
    </body>
</html>
```

Tal y como se puede ver en el ejemplo anterior, basta con escribir el nombre de la variable entre llaves `{{ }}`.
Es una buena práctica evitar mezclar el código PHP con nuestras vistas, por lo que toda la información que necesitemos en las vistas la ubicaremos fuera de ellas. Existen distintas formas de pasarle variables a las vistas:

La primera opción sería utilizando el método `with()`, pasándole como parámetros el nombre de la variable y su valor:

```php
Route::get('/', function () {
    $nombre = "Nora";
    return view('saludo')->with('nombre', $nombre);
});
```

Otra forma sería enviándolo como array:

```php
Route::get('/', function () {
    $nombre = "Nora";
    return view('saludo')->with(['nombre' => $nombre]);
});
```

También podríamos pasar el array como segundo parámetro de la función `view()` y no utilizar `with()`:

```php
Route::get('/', function () {
    $nombre = "Nora";
    return view('saludo',['nombre' => $nombre]);
});
```

Blade permite iterar por los datos de una colección o array. El siguiente ejemplo muestra cómo iterar por un array de strings de forma rápida:

```html
<!-- Vista almacenada en resources/views/articulos.blade.php -->
<html>
    <body>
	<h1>Vamos a leer al escritor {{ $nombre }}</h1>
        <h2>Estos son sus últimos artículos:</h2>
        <ul>
            @foreach ($articulos as $articulo)
                <li>{{ $articulo }}</li>
            @endforeach
        </ul>
    </body>
</html>
```

Para que la vista pueda acceder a los datos, es necesario proporcionárselos en la llamada al método `view()`:

```php
Route::get('/articulos', function () {
    $articulos = array('Primero', 'Segundo','Tercero', 'Último');
    return view('articulos', [
    	'nombre' => 'Ane Aranceta',
        'articulos' => $articulos
    ]);
})->name('articulos');
```

Los datos se le pasarán como un array de tipo clave-valor.

El motor de plantillas Blade permite el uso de todo tipo de estructuras:

```php
@for ($i = 0; $i < 10; $i++)
    El valor actual es {{ $i }}
@endfor

@foreach ($users as $user)
    <p>El usuario: {{ $user->id }}</p>
@endforeach

@forelse($users as $user)
    <li>{{ $user->name }}</li>
@empty
    <p>No users</p>
@endforelse

@while (true)
    <p>Eso es un bucle infinito.</p>
@endwhile

@if (count($articulos) === 1)
    Hay un artículo.
@elseif (count($articulos) > 1)
    Hay varios artículos.
@else
    No hay ninguno.
@endif

@unless (Auth::check())
    No estas autenticado.
@endunless
```

Puedes encontrar toda la información acerca de Blade en la [documentación oficial](https://laravel.com/docs/9.x/blade).


## Paso 4 - Crear un Controlador
Los controladores **contienen la lógica** para atender las peticiones recibidas. En otras palabras, un Controlador es una clase que agrupa el comportamiento de todas las peticiones **relacionadas con una misma entidad**. Por ejemplo, el controlador `ArticuloController` será el encargado de definir el comportamiento de acciones como: creación de un artículo, modificación de un artículo, búsqueda de artículos, etc.

#### Creando un Controller
Existen dos formas de crear un controlador:

- Crear manualmente una clase que extienda de la clase `Controller` de Laravel dentro del directorio `app/Http/Controllers`.
- Utilizar el comando de Artisan `make:controller`. Artisan es una herramienta que nos provee Laravel para interactuar con la aplicación y ejecutar instrucciones.

En este caso escogeremos la segunda opción y ejecutaremos el siguiente comando:

```
php artisan make:controller ArticuloController
# recuerda que si estás utilizado Sail el comando será: sail artisan ...
```

De este modo Laravel creará automáticamente un controlador vacío, que vendrá a ser una subclase de la clase `Controller`:.

```php
<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;

class ArticuloController extends Controller
{
    //
}
```

Como hemos comentado antes los controladores son los responsables de procesar las peticiones entrantes y devolver al cliente la respuesta. En el siguiente ejemplo se muestra cómo añadirle métodos que devuelvan vistas (como se puede ver en el caso de la función de nombre `show()`), es decir, mover la lógica de la aplicación del router al controlador.


```php
<?php

namespace App\Http\Controllers;

use App\Http\Controllers\Controller;
use App\User;

class ArticuloController extends Controller
{
    /**
     * Show the profile for the given user.
     *
     * @param  int  $id
     * @return View
     */
    public function show($id)
    {
        return view('articulos', ['articulo' => 'Mi primer artículo de Laravel');
    }
}
```

Es posible añadir más opciones al comando `make:controller`, aunque el único obligatorio es el nombre del controlador. Añadiendo `--resource` al comando anterior, Artisan añadirá al controlador creado los siete métodos REST más comunes: `index()`, `create()`, `store()`, `show()`, `edit()`, `update()`, `destroy()`:

```
php artisan make:controller ArticuloController --resource
```

Cada método tiene su función:

| Tipo  | URI | Método  | Acción  |
|---|---|---|---|
| GET | /articulos | index | Muestra todos los artículos  |
| GET | /articulos/create | create | Muestra el formulario para crear un artículo  |
| POST | /articulos | store | Guarda un nuevo artículo a partir de la información recibida  |
| GET | /articulos/{id} | show | Muestra la información de un artículo específico  |
| GET | /articulos/{id}/edit | edit | Muestra el formulario de edición de un artículo que ya existe  |
| PUT/PATCH | /articulos/{id} | update | Guardar los cambios del artículo indicado a partir de la información recibida |
| DELETE | /articulos/{id} | destroy | Elimina el artículo con el ID indicado |


#### Enrutar el Controlador
El siguiente paso es incluir en el Router las llamadas a los métodos del Controlador. En este caso crearemos las siguientes

```php
use App\Http\Controllers\ArticuloController;

Route::get('articulos/', [ArticuloController::class, 'index']);
Route::get('articulos/{id}', [ArticuloController::class, 'show']);
Route::get('articulos/{id}/create', [ArticuloController::class, 'create']);
Route::post('articulos/', [ArticuloController::class, 'store']);
```
De esta forma direccionaremos las peticiones a los métodos de los controladores. Recuerda que el router no debe incluir ninguna lógica de la aplicación, únicamente redireccionar las peticiones a los controladores.

Existe también otra forma más rápida para generar automáticamente las rutas a todos los métodos de nuestro controlador:

```php
Route::resource('articulos', ArticuloController::class);
```

Si ejecutamos el comando `php artisan route:list` podemos comprobar cómo ya disponemos de todas las rutas a nuestro recurso y que cada una apunta al método correspondiente en el controlador.

Esta opción también ofrece la posibilidad de generar únicamente las rutas que le indiquemos. El siguiente ejemplo muestra como generar únicamene las rutas index y create:

```php
Route::resource('articulos', ArticuloController::class)->only([
    'index', 'create'
]);
```


## Paso 5 - Configurar la base de datos
Es muy difícil de imaginar una aplicación web que no haga uso de una base de datos para almacenar la información. A continuación veremos como preparar la base de datos para nuestra aplicación.

#### Configuración de la base de datos
El fichero `.env` de Laravel contiene la configuración relacionada con la aplicación y el entorno, como por ejemplo la configuración de la base de datos. Abre el fichero `.env` para visualizar las credenciales de la base de datos:

```
DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=
DB_USERNAME=
DB_PASSWORD=
```
Todas estas variables de configuración serán referenciadas desde el archivo de configuración `database.php`.

#### (Opcional) Creación de la base de datos
Este paso solo será necesario si estamos utilizando Laravel Homestead y no le hemos indicado a Homestead en su archivo de configuración `Homestead.yaml` que cree una base de datos. Para crear la base de datos accede al cliente de MySQL como root:

```
mysql -u root
```

Crea la base de datos si no está creada:

```
CREATE DATABASE revistapp;
```

#### Creación del usuario para la base de datos
Es recomendable crear un usuario de base de datos para nuestra aplicación diferente a `root`. Para ello ejecuta los siguientes comandos:

```
mysql> CREATE USER 'dev'@'localhost' IDENTIFIED BY '12345Abcde';
Query OK, 0 rows affected (0.01 sec)

mysql> GRANT ALL PRIVILEGES ON * . * TO 'dev'@'localhost';
Query OK, 0 rows affected (0.00 sec)

mysql> FLUSH PRIVILEGES;
Query OK, 0 rows affected (0.00 sec)

```

## Paso 6 - Crear la Migración (Migration)
Las Migraciones (Migrations) se utilizan para construir el esquema de la base de datos, es decir, crear y modificar las tablas que utilizará nuestra aplicación. Ejecuta el siguiente comando de Artisan para crear una nueva Migración para una tabla que llamaremos "articulos". 

```
php artisan make:migration create_articulos_table --create=articulos
```

Laravel creará una nueva migración automáticamente en el directorio `database/migrations`. El nombre del archivo creado será el indicado en el comando anterior, en este caso `create_articulos_table`, precedido por un timestamp, por ejemplo: `2020_12_15_192620_create_articulos_table.php`.

El contenido de la clase creada será el siguiente:


```php
<?php

use Illuminate\Support\Facades\Schema;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;
  
class CreateArticulosTable extends Migration

{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('articulos', function (Blueprint $table) {
            // Completar con los campos que queremos que contenta la tabla 'articulos':
            $table->increments('id');
            $table->string('titulo'); 
            $table->text('contenido');
            $table->timestamps();
        });
    }

  

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::dropIfExists('articulos');
    }
}
```

Tal y como puedes deducir del código anterior, una migración contiene 2 métodos:

- `up()`: se utiliza para crear nuevas tablas, columnas o índices a la base de datos.
- `down()`: se utiliza para revertir operaciones realizadas por el método `up()`.

Existen una gran variedad de tipos de columnas disponibles para definir las tablas. Puedes encontrarlas en la [documentación oficial](https://laravel.com/docs/9.x/migrations#creating-columns).

Una vez tenemos definida una migración, solo quedará ejecutarla para que así se ejecute en nuestra base de datos. Para ejecutar las migraciones simplemente lanza el comando `migrate` de Artisan:

```
php artisan migrate
```

#### Crear usuario de base de datos
Es recomendable utilizar un usuario de base de datos diferente a `root`. Para ello, desde MySQL ejecuta lo siguiente:

```sql
CREATE USER 'nombre_usuario'@'localhost' IDENTIFIED BY 'tu_contrasena';
```

El comando anterior crea el usuario con la contraseña indicada. El siguiente paso es otorgar permisos al usuario:

```sql
GRANT ALL PRIVILEGES ON * . * TO 'nombre_usuario'@'localhost';
```

Para que los cambios surjan efecto ejecuta lo siguiente:

```sql
FLUSH PRIVILEGES;
```

No olvides actualizar los datos de acceso a base de datos en el fichero de configuración `.env`.

## Paso 7 - Crear un Modelo
Laravel incluye por defecto Eloquent ORM, el cual hace de la **interacción con la base de datos** una tarea fácil. Tal y como dice la documentación oficial:

>Each database table has a corresponding "Model" which is used to interact with that table. Models allow you to query for data in your tables, as well as insert new records into the table.

En otras palabras, cada tabla de la base de datos corresponde a un Modelo, el cual permite ejecutar operaciones sobre esa tabla (insertar o leer registros por ejemplo). Este patrón es conocido como Active Record Pattern.

El nombre del modelo será la forma singular del nombre asignado a la tabla de la base de datos. Por ejemplo: `User` será el modelo correspondiente a la tabla `users`.

#### Creando un Modelo
Vamos a crear un Modelo:

```
php artisan make:model Articulo
```

El comando anterior ha creado una clase llamada Articulo en el directorio `app/Models` (es el directorio por defecto para los modelos de Eloquent a partir de Laravel 8).

```php
<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class Articulo extends Model
{
    //
}
```

Por defecto un modelo de Eloquent almacena los registros en una tabla con el mismo nombre pero en plural. En este caso, `Articulo` interactuará con la tabla llamada `articulos`.

#### Recuperando datos de la base de datos
Los modelos de Eloquent se pueden utilizar para recuperar información de las tablas relacionadas con el modelo. Proporcionan métodos como los siguientes:

```php
use App\Models\Articulo;

// Recupera todos los modelos
$articulos = Articulo::all();

// Recupera un modelo a partir de su clave
$articulo = Articulo::find(1);

// Recupera el primer modelo que cumpla con los criterios indicados
$articulos = Articulo::where('active', 1)->first();

// Recupera los modelos que cumplan con los criterios indicados y de la forma indicada:
$articulos = Articulo::where('active', 1)
               ->orderBy('titulo', 'desc')
               ->take(10)
               ->get();

// Iterar sobre los resultados:
foreach ($articulos as $articulo) {
    echo $articulo->titulo;
}

```

#### Insertar, actualizar y borrar modelos

El siguiente controlador contiene toda la lógica para insertar, actualizar y borrar modelos:

```php
<?php
   
namespace App\Http\Controllers;
   
use App\Articulo;
use Illuminate\Http\Request;
use Redirect;
   
class ArticuloController extends Controller
{

    /**
     * Create a new articulo instance.
     *
     * @param  Request  $request
     * @return Response
     */
    public function store(Request $request)
    {
        // Validar la petición...

        $articulo = new Articulo;

        $articulo->titulo = request('titulo');

        $articulo->save();
    }
   
    /**
     * Update the specified resource in storage.
     *
     */
    public function update(Request $request, $id)
    {         
        $articulo = App\Articulo::find(1);

        $articulo->titulo = request('titulo');
        $articulo->contenido = request('contenido');

        $articulo->save();
    }
   
    /**
     * Remove the specified resource from storage.
     *
     */
    public function destroy($id)
    {
        // Encuentra el artículo por ID y lo elimina
        $articulo = App\Articulo::find($id);
        $articulo->delete();
        
        // Alternativa
        App\Articulo::destroy($id);
        
        //Borrar modelos por consulta (borra todos los que encuentre en la consulta)
        Articulo::where('id',$id)->delete();        
    }
     
}
```

Laravel proporciona alternativas para realizar operaciones más complejas, como creaciones en "masa" o crear un modelo solo si no existe:

```php
// Retrieve flight by name, or create it if it doesn't exist...
$articulo = App\Articulo::firstOrCreate(['name' => 'Laptop']);
```

Puedes encontrar todas las posibilidades en la [documentación oficial](https://laravel.com/docs/8.x/eloquent).

#### Alternativas a Eloquent ORM
Laravel también permite interactuar con la base de datos mediante otras técnicas distintas a Eloquent ORM. Las alternativas disponibles son:
- Raw SQL: se trata de ejecutar sentencias SQL directamente contra la base de datos. Tienes toda la información disponible [aquí](https://laravel.com/docs/8.x/database).
- Query Builder: es una interfaz de comunicación con la base de datos que permite lanzar prácticamente cualquier consulta. A diferencia de la anterior, no es tan eficiente en cuanto a rendimiento pero aporta otras ventajas como la seguridad y abstracción de base de datos. Tienes toda la información disponible [aquí](https://laravel.com/docs/8.x/queries).

#### Tinker: un potente REPL para Laravel
Tinker es un potente [REPL](https://es.wikipedia.org/wiki/REPL) o **consola interactiva** que viene por defecto en Laravel. Resulta muy útil durante el desarrollo ya que permite interactuar con nuestra aplicación Laravel y probar cantidad de cosas: eventos, acceso a datos, etc.
Para iniciar Tinker hay que ejecutar el siguiente comando:

```
php artisan tinker
```

A partir de ese momento se puede comenzar a interactuar con nuestra aplicación, como muestra el ejemplo a continuación:

```bash
>>> $articulo = new App\Models\Articulo
=> App\Articulo {#3014}
>>> $articulo->titulo="AA";
=> "AA"
>>> $articulo->contenido="BBBB";
=> "BBBB"
>>> $articulo
=> App\Models\Articulo {#3014
     titulo: "Articulo numero 2",
     contenido: "Lorem ipsum...",
   }
>>> $articulos->save();
>>> App\Models\Articulo::count();
=> 2
>>> $articulos = App\Models\Articulo::all();
=> Illuminate\Database\Eloquent\Collection {#3035
     all: [
       App\Models\Articulo {#3036
         id: 1,
         titulo: "Articulo numero 1",
         contenido: "Lorem ipsum...",
         created_at: null,
         updated_at: null,
       },
       App\Models\Articulo {#3046
         id: 2,
         titulo: "Articulo numero 2",
         contenido: "Lorem ipsum...",
         created_at: "2019-12-15 15:32:04",
         updated_at: "2019-12-15 15:32:04",
       },
     ],
   }

```

Para salir se ejecuta el comando `exit`.

## Bonus - Opciones (flags) de Artisan
Existen opciones muy útiles para generar archivos relacionados con los modelos. El siguiente ejemplo crea un modelo junto con su controlador y migración utilizando un único comando:

```
php artisan make:model Articulo -mcr
```

- -m indica la creación de una migración
- -c indica la creación de un controlador
- -r indica que el controlador creado será "resourceful" (incializado con los métodos).

## Práctica 1
Crea una aplicación Laravel que muestre un listado de artículos de la base de datos.

## Práctica 2
Añade a la aplicación anterior una nueva vista que muestre el detalle de un artículo. Se accederá desde la vista del listado de artículos.

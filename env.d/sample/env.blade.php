<p>{{ env('DB_DATABASE') }}</p>
<p>{{ env('DB_CONNECTION') }}</p>
<p>{{ env('DB_HOST') }}</p>
<p>{{ env('DB_USERNAME') }}</p>
<p>{{ env('APP_NAME') }}</p>
<p>{{ env('APP_ENV', 'production') }}</p>
<p>{{ getenv('APP_ENV') }}</p>
<p>{{ App::environment() }}</p>
<p>{{ env('APP_DEBUG') }}</p>
<p>{{ env('DARABASE_URL') }}</p>

{{-- <p>{{ env('SESSION_DRIVER', 'file') }}</p>
<p>{{ env('APP_DEBUG', false) }}</p>
<p>{{ env('SESSION_LIFETIME', 120) }}</p>
<p>{{ env('REDIS_URL') }}</p>
<p>{{ env('REDIS_HOST', '127.0.0.1') }}</p>
<p>{{ env('REDIS_DB', '0') }}</p>
<p>{{ env('CACHE_DRIVER', 'file') }}</p> --}}

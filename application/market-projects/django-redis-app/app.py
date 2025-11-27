import os
import django
from django.conf import settings
from django.http import JsonResponse
from django.urls import path
from django.core.wsgi import get_wsgi_application
import redis
import json

# Django settings
settings.configure(
    DEBUG=True,
    SECRET_KEY='django-insecure-key-for-demo',
    ROOT_URLCONF=__name__,
    ALLOWED_HOSTS=['*'],
    CACHES={
        'default': {
            'BACKEND': 'django_redis.cache.RedisCache',
            'LOCATION': 'redis://redis:6379/1',
            'OPTIONS': {
                'CLIENT_CLASS': 'django_redis.client.DefaultClient',
            }
        }
    }
)

django.setup()

from django.core.cache import cache

# Redis client
redis_client = redis.Redis(host='redis', port=6379, db=0, decode_responses=True)

def home(request):
    return JsonResponse({
        'message': 'Django + Redis Caching App',
        'endpoints': ['/cache/<key>/<value>', '/get/<key>', '/health']
    })

def set_cache(request, key, value):
    try:
        # Set in Django cache
        cache.set(key, value, timeout=300)
        # Set in Redis directly
        redis_client.set(f"direct_{key}", value, ex=300)
        return JsonResponse({
            'status': 'success',
            'message': f'Cached {key} = {value}',
            'ttl': 300
        })
    except Exception as e:
        return JsonResponse({'error': str(e)}, status=500)

def get_cache(request, key):
    try:
        # Get from Django cache
        django_value = cache.get(key)
        # Get from Redis directly
        redis_value = redis_client.get(f"direct_{key}")
        
        return JsonResponse({
            'key': key,
            'django_cache': django_value,
            'redis_direct': redis_value,
            'cache_hit': django_value is not None
        })
    except Exception as e:
        return JsonResponse({'error': str(e)}, status=500)

def health(request):
    try:
        # Test Redis connection
        redis_client.ping()
        return JsonResponse({
            'status': 'healthy',
            'redis': 'connected',
            'django': 'running'
        })
    except Exception as e:
        return JsonResponse({
            'status': 'unhealthy',
            'error': str(e)
        }, status=500)

urlpatterns = [
    path('', home),
    path('cache/<str:key>/<str:value>/', set_cache),
    path('get/<str:key>/', get_cache),
    path('health/', health),
]

application = get_wsgi_application()

if __name__ == '__main__':
    from django.core.management import execute_from_command_line
    execute_from_command_line(['manage.py', 'runserver', '0.0.0.0:8000'])
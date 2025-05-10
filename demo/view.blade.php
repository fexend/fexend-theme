@extends('layouts.app')

@section('title', 'Test Page')

@section('content')
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-md-8">
                <div class="card">
                    <div class="card-header">{{ __('Dashboard') }}</div>

                    <div class="card-body">
                        @if (session('status'))
                            <div class="alert alert-success" role="alert">
                                {{ session('status') }}
                            </div>
                        @endif

                        <h2>{{ __('Welcome to our test page') }}</h2>

                        <p>This is a Blade template example.</p>

                        @auth
                            <div class="alert alert-info">
                                You are logged in as {{ Auth::user()->name }}!
                            </div>

                            @if (Auth::user()->isAdmin())
                                <div class="admin-panel">
                                    <h3>Admin Controls</h3>
                                    <ul>
                                        <li><a href="{{ route('admin.users') }}">Manage Users</a></li>
                                        <li><a href="{{ route('admin.settings') }}">Site Settings</a></li>
                                    </ul>
                                </div>
                            @endif
                        @else
                            <p>Please <a href="{{ route('login') }}">login</a> to access more features.</p>
                        @endauth

                        @foreach ($items as $item)
                            <div class="item">
                                <h4>{{ $item->title }}</h4>
                                <p>{{ $item->description }}</p>
                            </div>
                        @endforeach
                    </div>
                </div>
            </div>
        </div>
    </div>
@endsection

@push('scripts')
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            console.log('Blade template loaded!');
        });
    </script>
@endpush

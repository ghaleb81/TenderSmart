<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\Response;

class CheckUser
{
    /**
     * Handle an incoming request.
     *
     * @param  \Closure(\Illuminate\Http\Request): (\Symfony\Component\HttpFoundation\Response)  $next
     */
  public function handle($request, Closure $next, ...$roles): Response
{
    $user = $request->user();

    if (!$user) {
        return response()->json(['error' => 'User not authenticated'], 401);
    }

    if (!in_array($user->role, $roles)) {
        return response()->json([
            'error' => 'Unauthorized role: ' . $user->role,
            'expected' => $roles,
        ], 403);
    }

    return $next($request);
}

}
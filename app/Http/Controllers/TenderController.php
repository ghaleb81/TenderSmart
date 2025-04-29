<?php

namespace App\Http\Controllers;

use App\Models\Tender;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Storage;

class TenderController extends Controller   
{
    
    public function index()
    {
        $tenders = Tender::all();
        return view('dashboard', compact(var_name: 'tenders'));
    }

    /**
     * تخزين مناقصة جديدة.
     */
    public function store(Request $request)
    {
        $request->validate([
            'title' => 'required|string|max:255',
            'description' => 'required|string',
            'location' => 'required|string|max:255',
            'estimated_budget' => 'nullable|numeric',
            'execution_duration_days' => 'nullable|integer',
            'submission_deadline' => 'required|date|after:today',
            'technical_requirements_count' => 'nullable|integer|min:0',
            'attached_file' => 'nullable|file|mimes:pdf,doc,docx,zip',
        ]);

        $data = $request->except('attached_file');

        if ($request->hasFile('attached_file')) {
            $filePath = $request->file('attached_file')->store('tender_files', 'public');
            $data['attached_file'] = $filePath;
        }

        Tender::create($data);

        return redirect()->back()->with('success', 'تم إنشاء المناقصة بنجاح.');
    }

    /**
     * عرض تفاصيل مناقصة محددة.
     */
    public function show($id)
    {
        $tender = Tender::with('bids')->findOrFail($id);
        return view('tenders.show', compact('tender'));
    }

    /**
     * تحديث مناقصة محددة.
     */
    public function update(Request $request, $id)
    {
        $tender = Tender::findOrFail($id);

        $request->validate([
            'title' => 'required|string|max:255',
            'description' => 'required|string',
            'location' => 'required|string|max:255',
            'estimated_budget' => 'nullable|numeric',
            'execution_duration_days' => 'nullable|integer',
            'submission_deadline' => 'required|date',
            'technical_requirements_count' => 'nullable|integer|min:0',
            'attached_file' => 'nullable|file|mimes:pdf,doc,docx,zip',
        ]);

        $data = $request->except('attached_file');

        if ($request->hasFile('attached_file')) {
            if ($tender->attached_file) {
                Storage::disk('public')->delete($tender->attached_file);
            }
            $filePath = $request->file('attached_file')->store('tender_files', 'public');
            $data['attached_file'] = $filePath;
        }

        $tender->update($data);

        return redirect()->back()->with('success', 'تم تحديث المناقصة بنجاح.');
    }

    /**
     * حذف مناقصة.
     */
    public function destroy($id)
    {
        $tender = Tender::findOrFail($id);

        if ($tender->attached_file) {
            Storage::disk('public')->delete($tender->attached_file);
        }

        $tender->delete();

        return redirect()->back()->with('success', 'تم حذف المناقصة بنجاح.');
    }
}

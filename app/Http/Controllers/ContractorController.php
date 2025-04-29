<?php

namespace App\Http\Controllers;

use App\Models\Contractor;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Storage;

class ContractorController extends Controller
{
    /**
     * Show the contractor form.
     */
    public function create()
    {
        return view('contractors.create');
    }

    /**
     * Store contractor data.
     */
    public function store(Request $request)
    {
        $request->validate([
            'company_name' => 'required|string|max:255',
            'commercial_registration_number' => 'required|string|max:255',
            'company_email' => 'required|email|max:255',
            'country' => 'required|string|max:255',
            'city' => 'nullable|string|max:255',
            'phone_number' => 'required|string|max:20',
            'year_established' => 'required|digits:4|integer|min:1900|max:' . date('Y'),
            'projects_last_5_years' => 'required|integer|min:0',
            'quality_certificates' => 'nullable|array',
            'quality_certificates.*' => 'string',
            'public_sector_successful_contracts' => 'nullable|string',
            'website_url' => 'nullable|url|max:255',
            'linkedin_profile' => 'nullable|url|max:255',
            'company_bio' => 'nullable|string',
            'official_documents' => 'nullable|file|mimes:pdf,doc,docx,zip',
        ]);

        $data = $request->except('official_documents');
        $data['user_id'] = Auth::id();

        if ($request->hasFile('official_documents')) {
            $filePath = $request->file('official_documents')->store('contractor_documents', 'public');
            $data['official_documents'] = $filePath;
        }

        Contractor::updateOrCreate(
            ['user_id' => Auth::id()],
            $data
        );

        return redirect()->back()->with('success', 'تم حفظ بيانات المقاول بنجاح.');
    }
}

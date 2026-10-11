import Foundation

// Keep the public privacy page consistent with this offline policy.
enum RunConvertPrivacy {
    static let policyURL = URL(string: "https://runconvert.vercel.app/privacy")!
    static let supportURL = URL(string: "https://runconvert.vercel.app/support")!

    static let policy = """
    RunConvert Privacy Policy
    Updated September 27, 2026

    RunConvert works offline. Pace, distance, time, and workout values are processed on your device. The app does not send those values to me or anyone else.

    The app does not collect personal data, use analytics or advertising SDKs, track you, or require an account. It does not access Apple Health, location, contacts, photos, or your microphone.

    Inputs are held in memory while the app is running. The app does not save a workout history or upload your entries. Clear removes the entries from the current converter. There is no server-side account or stored data to delete.

    Apple may separately process App Store purchases, downloads, or diagnostic information under its own privacy settings and policies.

    If you email support, I receive your email address and the information you choose to send so I can respond. Messages may remain in the support mailbox; you can request deletion by emailing aisolorzano98@hotmail.com.

    Opening the website or emailing support uses your browser or email service separately. The website is hosted on Vercel, which may process technical request information to deliver and secure the site. The full website policy explains this separately from the offline app.
    """
}

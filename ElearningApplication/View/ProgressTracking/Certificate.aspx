<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Certificate.aspx.cs" Inherits="ElearningApplication.View.ProgressTracking.Certificate" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Certificate of Accomplishment</title>
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700;800&family=Playfair+Display:ital,wght@0,400;0,600;0,700;1,400&display=swap" rel="stylesheet" />
    <style>
        :root {
            --primary: #6366f1;
            --primary-hover: #4f46e5;
            --gold: #d4af37;
            --gold-light: #f3e5ab;
            --dark-blue: #0f172a;
            --card-bg: #ffffff;
            --bg-gradient: linear-gradient(135deg, #1e1b4b 0%, #0f172a 100%);
            --text-main: #1e293b;
            --text-muted: #64748b;
        }

        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }

        body {
            font-family: 'Outfit', sans-serif;
            background: var(--bg-gradient);
            color: #ffffff;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            padding: 40px 20px;
        }

        .controls-container {
            width: 100%;
            max-width: 900px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 24px;
        }

        .btn {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 12px 24px;
            border-radius: 12px;
            font-weight: 600;
            font-size: 14px;
            text-decoration: none;
            cursor: pointer;
            transition: all 0.2s ease;
            border: none;
        }

        .btn-back {
            background: rgba(255, 255, 255, 0.1);
            color: #ffffff;
            border: 1px solid rgba(255, 255, 255, 0.15);
        }

        .btn-back:hover {
            background: rgba(255, 255, 255, 0.2);
            transform: translateX(-2px);
        }

        .btn-print {
            background: linear-gradient(135deg, #d97706 0%, #b45309 100%);
            color: #ffffff;
            box-shadow: 0 4px 12px rgba(180, 83, 9, 0.3);
        }

        .btn-print:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 16px rgba(180, 83, 9, 0.4);
        }

        /* Certificate Container */
        .certificate-wrapper {
            background: var(--card-bg);
            color: var(--text-main);
            width: 100%;
            max-width: 900px;
            height: 630px;
            padding: 40px;
            border-radius: 4px;
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.4);
            position: relative;
            overflow: hidden;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            align-items: center;
        }

        /* Elaborate borders */
        .cert-border-outer {
            position: absolute;
            top: 15px;
            left: 15px;
            right: 15px;
            bottom: 15px;
            border: 4px double var(--gold);
            pointer-events: none;
        }

        .cert-border-inner {
            position: absolute;
            top: 25px;
            left: 25px;
            right: 25px;
            bottom: 25px;
            border: 1px solid rgba(212, 175, 55, 0.5);
            pointer-events: none;
        }

        .corner-ornament {
            position: absolute;
            width: 40px;
            height: 40px;
            border: 2px solid var(--gold);
            pointer-events: none;
        }

        .corner-top-left { top: 22px; left: 22px; border-right: none; border-bottom: none; }
        .corner-top-right { top: 22px; right: 22px; border-left: none; border-bottom: none; }
        .corner-bottom-left { bottom: 22px; left: 22px; border-right: none; border-top: none; }
        .corner-bottom-right { bottom: 22px; right: 22px; border-left: none; border-top: none; }

        /* Background watermark */
        .cert-watermark {
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            font-size: 320px;
            color: rgba(241, 245, 249, 0.8);
            opacity: 0.12;
            z-index: 0;
            pointer-events: none;
            user-select: none;
        }

        /* Certificate Content */
        .cert-header {
            text-align: center;
            z-index: 1;
        }

        .cert-logo {
            font-size: 28px;
            font-weight: 800;
            letter-spacing: 2px;
            background: linear-gradient(135deg, #1e1b4b 0%, #6366f1 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            margin-bottom: 8px;
        }

        .cert-subtitle {
            font-size: 11px;
            text-transform: uppercase;
            letter-spacing: 4px;
            color: var(--text-muted);
            font-weight: 600;
        }

        .cert-body {
            text-align: center;
            z-index: 1;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            flex-grow: 1;
            margin: 20px 0;
        }

        .cert-title {
            font-family: 'Playfair Display', serif;
            font-size: 36px;
            font-weight: 700;
            color: #0f172a;
            margin-bottom: 15px;
        }

        .cert-award-text {
            font-size: 14px;
            font-style: italic;
            color: var(--text-muted);
            margin-bottom: 12px;
        }

        .cert-recipient {
            font-family: 'Playfair Display', serif;
            font-size: 38px;
            font-weight: 700;
            color: var(--primary);
            border-bottom: 2px solid #e2e8f0;
            padding-bottom: 5px;
            margin-bottom: 15px;
            min-width: 320px;
            display: inline-block;
        }

        .cert-course-intro {
            font-size: 13px;
            color: var(--text-muted);
            margin-bottom: 10px;
        }

        .cert-course-title {
            font-family: 'Playfair Display', serif;
            font-size: 26px;
            font-weight: 700;
            color: #0f172a;
            margin-bottom: 20px;
        }

        /* Footer section */
        .cert-footer {
            width: 100%;
            display: flex;
            justify-content: space-between;
            align-items: flex-end;
            padding: 0 40px;
            z-index: 1;
        }

        .cert-meta-item {
            text-align: center;
            flex: 1;
        }

        .cert-signature-line {
            width: 200px;
            border-top: 1px solid #94a3b8;
            margin: 0 auto 6px auto;
            padding-top: 8px;
            font-style: italic;
            font-size: 15px;
            color: #334155;
            font-family: 'Playfair Display', serif;
        }

        .cert-meta-label {
            font-size: 11px;
            color: var(--text-muted);
            text-transform: uppercase;
            letter-spacing: 1px;
            font-weight: 500;
        }

        .cert-meta-val {
            font-size: 14px;
            font-weight: 600;
            color: #1e293b;
        }

        /* Gold Seal */
        .cert-seal-container {
            flex: 1;
            display: flex;
            justify-content: center;
            align-items: center;
        }

        .cert-seal {
            width: 85px;
            height: 85px;
            background: radial-gradient(circle, #f3e5ab 0%, #d4af37 60%, #aa7c11 100%);
            border-radius: 50%;
            box-shadow: 0 4px 10px rgba(0,0,0,0.15), inset 0 0 10px rgba(255,255,255,0.4);
            display: flex;
            align-items: center;
            justify-content: center;
            position: relative;
            border: 2px dashed #aa7c11;
        }

        .cert-seal::before {
            content: '★ SEAL ★';
            font-size: 10px;
            font-weight: 700;
            color: #5c4008;
            letter-spacing: 1px;
        }

        /* Security Verification Footer */
        .cert-verification {
            position: absolute;
            bottom: 30px;
            left: 0;
            right: 0;
            text-align: center;
            font-size: 10px;
            color: #94a3b8;
            font-family: monospace;
            letter-spacing: 1.5px;
            z-index: 1;
        }

        /* Print styling rules */
        @media print {
            @page {
                size: landscape;
                margin: 0;
            }
            body {
                background: #ffffff;
                color: #000000;
                padding: 0;
                margin: 0;
                height: 100vh;
                display: flex;
                align-items: center;
                justify-content: center;
            }
            .controls-container {
                display: none !important;
            }
            .certificate-wrapper {
                box-shadow: none !important;
                border: none !important;
                background: #ffffff !important;
                width: 100% !important;
                max-width: 100% !important;
                height: 100% !important;
                padding: 50px !important;
                position: fixed !important;
                top: 0 !important;
                left: 0 !important;
                right: 0 !important;
                bottom: 0 !important;
                page-break-inside: avoid;
            }
            .btn {
                display: none !important;
            }
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <!-- Control buttons -->
        <div class="controls-container">
            <asp:LinkButton ID="btnBackProgress" runat="server" OnClick="btnBackProgress_Click" CssClass="btn btn-back">
                ← Back to Progress
            </asp:LinkButton>
            <button type="button" onclick="window.print();" class="btn btn-print">
                🖨️ Print Certificate
            </button>
        </div>

        <!-- Certificate Container -->
        <div class="certificate-wrapper">
            <!-- Decorative borders -->
            <div class="cert-border-outer"></div>
            <div class="cert-border-inner"></div>
            <div class="corner-ornament corner-top-left"></div>
            <div class="corner-ornament corner-top-right"></div>
            <div class="corner-ornament corner-bottom-left"></div>
            <div class="corner-ornament corner-bottom-right"></div>

            <!-- Watermark -->
            <div class="cert-watermark">🎓</div>

            <!-- Header -->
            <div class="cert-header">
                <div class="cert-logo">ANTIGRAVITY ACADEMY</div>
                <div class="cert-subtitle">E-Learning Excellence & Accomplishment</div>
            </div>

            <!-- Body -->
            <div class="cert-body">
                <div class="cert-title">CERTIFICATE OF COMPLETION</div>
                <div class="cert-award-text">This is proudly presented to</div>
                <div class="cert-recipient">
                    <asp:Literal ID="litStudentName" runat="server">John Doe</asp:Literal>
                </div>
                <div class="cert-course-intro">for successfully mastering all course requirements and passing all assessments of</div>
                <div class="cert-course-title">
                    <asp:Literal ID="litCourseTitle" runat="server">Advanced Web Application Development</asp:Literal>
                </div>
            </div>

            <!-- Footer -->
            <div class="cert-footer">
                <!-- Instructor Details -->
                <div class="cert-meta-item">
                    <div class="cert-signature-line">
                        <asp:Literal ID="litInstructorName" runat="server">Prof. Jane Smith</asp:Literal>
                    </div>
                    <div class="cert-meta-label">Course Instructor</div>
                </div>

                <!-- Golden Seal -->
                <div class="cert-seal-container">
                    <div class="cert-seal"></div>
                </div>

                <!-- Date details -->
                <div class="cert-meta-item">
                    <div class="cert-meta-val">
                        <asp:Literal ID="litCompletionDate" runat="server">May 28, 2026</asp:Literal>
                    </div>
                    <div class="cert-meta-label">Date of Issuance</div>
                </div>
            </div>

            <!-- Security verification footer -->
            <div class="cert-verification">
                VERIFICATION ID: <asp:Literal ID="litVerificationCode" runat="server">CERT-XXXX-XXXX</asp:Literal>
            </div>
        </div>
    </form>
</body>
</html>

<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="UploadMaterial.aspx.cs"
    Inherits="ElearningApplication.View.Instructor.UploadMaterial" %>

    <!DOCTYPE html>
    <html xmlns="http://www.w3.org/1999/xhtml">

    <head runat="server">
        <title>Upload Course Material</title>
        <style>
            body {
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                background-color: #f0f2f5;
                margin: 0;
                padding: 20px;
                display: flex;
                justify-content: center;
            }

            .container {
                background-color: #fff;
                padding: 30px;
                border-radius: 12px;
                box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
                width: 100%;
                max-width: 600px;
            }

            h2 {

                text-align: center;
                margin-top: 0;
            }

            .form-group {
                margin-bottom: 20px;
            }

            label {
                display: block;
                margin-bottom: 8px;
                font-weight: 600;
                color: #333;
            }

            .form-control {
                width: 100%;
                padding: 10px;
                border: 1px solid #ccc;
                border-radius: 6px;
                box-sizing: border-box;
                font-size: 14px;
            }

            .drop-zone {
                width: 100%;
                height: 200px;
                border-radius: 10px;
                display: flex;
                align-items: center;
                justify-content: center;
                text-align: center;
                position: relative;
                background-color: #f8faff;
                transition: all 0.3s ease;
                cursor: pointer;
                box-sizing: border-box;
            }

            .drop-zone.dragover {
                background-color: #e8f0fe;

            }

            .drop-zone-text {

                font-size: 16px;
                font-weight: bold;
                pointer-events: none;
            }

            .drop-zone-text span {
                display: block;
                font-size: 12px;
                color: #666;
                margin-top: 8px;
                font-weight: normal;
            }

            /* Make file input invisible but cover the drop zone */
            .file-input {
                position: absolute;
                width: 100%;
                height: 100%;
                top: 0;
                left: 0;
                opacity: 0;
                cursor: pointer;
            }

            .btn-upload {

                color: white;
                border: none;
                padding: 12px 20px;
                border-radius: 6px;
                cursor: pointer;
                font-size: 16px;
                font-weight: bold;
                width: 100%;
                transition: background-color 0.3s;
            }

            .btn-upload:hover {
                background-color: #bdeb41;
            }

            .message {
                margin-top: 15px;
                padding: 10px;
                border-radius: 6px;
                text-align: center;
                font-weight: bold;
            }

            .message.success {
                background-color: #d4edda;
                color: #155724;
                border: 1px solid #c3e6cb;
            }

            .message.error {
                background-color: #f8d7da;
                color: #721c24;
                border: 1px solid #f5c6cb;
            }

            #file-name-display {
                margin-top: 10px;
                font-style: italic;
                text-align: center;
            }

            .back-link {
                display: inline-block;
                margin-bottom: 20px;
                text-decoration: none;
                font-weight: bold;
            }

            .back-link:hover {
                text-decoration: underline;
            }
        </style>
    </head>

    <body>
        <form id="form1" runat="server">
            <div class="container">
                <a href="ManageModules.aspx" class="back-link">&larr; Back to Instructor Panel</a>
                <h2>Upload Course Material</h2>

                <asp:Panel ID="pnlMessage" runat="server" Visible="false" CssClass="message">
                    <asp:Label ID="lblMessage" runat="server"></asp:Label>
                </asp:Panel>

                <div class="form-group">
                    <label for="ddlCourses">Select Course</label>
                    <asp:DropDownList ID="ddlCourses" runat="server" CssClass="form-control"
                        AppendDataBoundItems="true">
                        <asp:ListItem Text="-- Select a Course --" Value="" />
                    </asp:DropDownList>
                </div>

                <div class="form-group">
                    <label for="txtTitle">Material Title</label>
                    <asp:TextBox ID="txtTitle" runat="server" CssClass="form-control"
                        placeholder="E.g., Chapter 1 Notes"></asp:TextBox>
                </div>

                <div class="form-group">
                    <label>File Upload</label>
                    <div class="drop-zone" id="drop-zone">
                        <div class="drop-zone-text" id="drop-zone-text">
                            Drag & Drop your file here
                            <span>or click to browse</span>
                        </div>
                        <asp:FileUpload ID="fileUpload" runat="server" CssClass="file-input"
                            onchange="displayFileName(this)" />
                    </div>
                    <div id="file-name-display">No file selected</div>
                </div>

                <asp:Button ID="btnSubmit" runat="server" Text="Upload Material" CssClass="btn-upload"
                    OnClick="btnSubmit_Click" />

            </div>

            <script>
                // Add visual feedback for drag and drop
                const dropZone = document.getElementById('drop-zone');
                const fileInput = document.getElementById('<%= fileUpload.ClientID %>');
                const fileNameDisplay = document.getElementById('file-name-display');
                const dropZoneText = document.getElementById('drop-zone-text');

                dropZone.addEventListener('dragover', (e) => {
                    e.preventDefault();
                    dropZone.classList.add('dragover');
                });

                dropZone.addEventListener('dragleave', () => {
                    dropZone.classList.remove('dragover');
                });

                dropZone.addEventListener('drop', (e) => {
                    dropZone.classList.remove('dragover');
                    // The file input handles the drop natively since it covers the dropzone
                });

                function displayFileName(input) {
                    if (input.files && input.files.length > 0) {
                        fileNameDisplay.textContent = 'Selected file: ' + input.files[0].name;
                        dropZone.style.borderColor = '#28a745';
                        dropZone.style.backgroundColor = '#f0fff4';
                        dropZoneText.innerHTML = 'File Ready!<br><span style="color:#28a745">Click to change</span>';
                    } else {
                        fileNameDisplay.textContent = 'No file selected';
                        dropZone.style.borderColor = '#1a73e8';
                        dropZone.style.backgroundColor = '#f8faff';
                        dropZoneText.innerHTML = 'Drag & Drop your file here<br><span>or click to browse</span>';
                    }
                }
            </script>
        </form>
    </body>

    </html>
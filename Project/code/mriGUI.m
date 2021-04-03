function varargout = mriGUI(varargin)
% MRIGUI MATLAB code for mriGUI.fig
%      MRIGUI, by itself, creates a new MRIGUI or raises the existing
%      singleton*.
%
%      H = MRIGUI returns the handle to a new MRIGUI or the handle to
%      the existing singleton*.
%
%      MRIGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MRIGUI.M with the given input arguments.
%
%      MRIGUI('Property','Value',...) creates a new MRIGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before mriGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to mriGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help mriGUI

% Last Modified by GUIDE v2.5 10-Jan-2021 22:59:03

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @mriGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @mriGUI_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT

% --- Executes just before mriGUI is made visible.
function mriGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to mriGUI (see VARARGIN)

% Choose default command line output for mriGUI
handles.output = hObject;

% [T1map, T2map, T2smap, PDmap, CSHmap] = load_data();
% G_z = 4e-2; %4G/cm in T/m
% v_bar_frac = 0.5;
% slice_thic = 1;
% tp = 1e-6;
% 
% [handles.T1sl, handles.T2sl, handles.T2ssl, handles.PDsl, handles.CSHsl, handles.alpha] = ...
%     slice_select(T1map, T2map, T2smap, PDmap, CSHmap, G_z, v_bar_frac, slice_thic, tp);
xFov = 181;
yFov = 217;
handles.s0 = zeros(yFov, xFov);
handles.image = zeros(yFov, xFov);
handles.tspace = 0:0.0001:constants.TE + constants.TS_1 * xFov / 2;
handles.gx = zeros(length(handles.tspace));
handles.gy = zeros(length(handles.tspace));
handles.non_ideal_mode = [0; 0; 0];
handles.slider1.Value = 0.5;
handles.curr_slice = 0.5;
handles.slice_text.String = floor(handles.curr_slice * 180);
handles.slider_min = 0;
handles.slider_max = 1;
handles.thickness = 1;
% handles.contrast_group.Buttons = [handles.t1_button handles.t2_button handles.pd_button];

% Update handles structure
guidata(hObject, handles);

% This sets up the initial plot - only do when we are invisible
% so window can get raised using mriGUI.
if strcmp(get(hObject,'Visible'),'off')
    axes(handles.k_axes);
    imshow(abs(handles.s0), []);
    title('Computed k-space data')
    axes(handles.image_axes);
    imshow(handles.image, []);
    title('Constructed image')
    axes(handles.pulse_axes_x);
    plot(handles.tspace, handles.gx);
    title('G_x pulse')
    xlabel('Time(s)')
    axes(handles.pulse_axes_y);
    plot(handles.tspace, handles.gy);
    title('G_y pulse')
    xlabel('Time(s)')
end

% UIWAIT makes mriGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = mriGUI_OutputFcn(hObject, eventdata, handles)
varargout{1} = handles.output;

% --- Executes on button press in compute_button.
function compute_button_Callback(hObject, eventdata, handles)
% objHandles = guihandles(hObject);
f = waitbar(0.1, 'Loading Data...');

[T1map, T2map, T2smap, PDmap, CSHmap] = load_data();
G_z = 4e-2; %4G/cm in T/m
v_bar_frac = handles.curr_slice; % str2double( get(handles.slice_selection_bar, 'String') );
slice_thic = handles.thickness;
tp = 1e-6;

if handles.gradient_button.Value == 1
    pulse_type = 'grad';
elseif handles.spin_button.Value == 1
    pulse_type = 'spin';
end

if handles.t1_button.Value == 1
    contrast_mode = 'T1';
elseif handles.t2_button.Value == 1
    contrast_mode = 'T2';
elseif handles.pd_button.Value == 1
    contrast_mode = 'PD';
end

[handles.T1sl, handles.T2sl, handles.T2ssl, handles.PDsl, handles.CSHsl, handles.alpha] = ...
    slice_select(T1map, T2map, T2smap, PDmap, CSHmap, G_z, v_bar_frac, slice_thic, ...
    contrast_mode, pulse_type);

guidata(hObject, handles);

waitbar(.60, f, 'Computing k-space');

disp(handles.non_ideal_mode)


[handles.s0, handles.gx, handles.gy, handles.tspace] = compute_k(...
    handles.alpha, handles.T1sl, handles.T2sl, handles.T2ssl, ...
    handles.PDsl, handles.CSHsl, handles.non_ideal_mode, contrast_mode, pulse_type, handles.noise_box.Value);

% popup_sel_index = get(handles.mode_menu, 'Value');

% disp(popup_sel_index)
% switch popup_sel_index
%     case 1 %% T2
%         [handles.s0, handles.gx, handles.gy] = compute_k(...
%             handles.alpha, handles.T1sl, handles.T2sl, handles.T2ssl, ...
%             handles.PDsl, handles.CSHsl, 'T2Decay');
%         
%     case 2 %% chemical shift
%         [handles.s0, handles.gx, handles.gy] = compute_k(...
%             handles.alpha, handles.T1sl, handles.T2sl, handles.T2ssl, ...
%             handles.PDsl, handles.CSHsl, 'Chemical Shift');
%         
%     case 3 %% proton density
%         [handles.s0, handles.gx, handles.gy] = compute_k(...
%             handles.alpha, handles.T1sl, handles.T2sl, handles.T2ssl, ...
%             handles.PDsl, handles.CSHsl, 'Proton Density');
% end

waitbar(.90, f, 'Constructing Image');
guidata(hObject, handles);
handles.image = reconstruct_image(handles.s0);
guidata(hObject, handles);

axes(handles.k_axes);
cla;
imshow(log(abs(fftshift(handles.s0, 2))), []);
title('Computed k-space data')

axes(handles.image_axes);
cla;
% imshow(abs(fftshift(handles.image)), []);
imshow(abs(handles.image), []);
title('Constructed image')

axes(handles.pulse_axes_x);
cla;
plot(handles.tspace, handles.gx);
title('G_x pulse')
xlabel('Time(s)')

axes(handles.pulse_axes_y);
cla;
plot(handles.tspace, handles.gy);
title('G_y pulse')
xlabel('Time(s)')

close(f)
guidata(hObject, handles);

% --------------------------------------------------------------------
function FileMenu_Callback(hObject, eventdata, handles)

% --------------------------------------------------------------------
function OpenMenuItem_Callback(hObject, eventdata, handles)
file = uigetfile('*.fig');
if ~isequal(file, 0)
    open(file);
end

% --------------------------------------------------------------------
function PrintMenuItem_Callback(hObject, eventdata, handles)
printdlg(handles.figure1)

% --------------------------------------------------------------------
function CloseMenuItem_Callback(hObject, eventdata, handles)
selection = questdlg(['Close ' get(handles.figure1,'Name') '?'],...
                     ['Close ' get(handles.figure1,'Name') '...'],...
                     'Yes','No','Yes');
if strcmp(selection,'No')
    return;
end

delete(handles.figure1)

% --- Executes on selection change in mode_menu.
function mode_menu_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function mode_menu_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
     set(hObject,'BackgroundColor','white');
end

set(hObject, 'String', {'T2 Decay', 'Chemical Shift', 'Proton Density'});

function thickness_bar_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function thickness_bar_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function slice_selection_bar_Callback(hObject, eventdata, handles)

function slice_selection_bar_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in t2_decay_box.
function t2_decay_box_Callback(hObject, eventdata, handles)
% hObject    handle to t2_decay_box (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.non_ideal_mode(1) = get(hObject, 'Value');
guidata(hObject, handles)
% Hint: get(hObject,'Value') returns toggle state of t2_decay_box


% --- Executes on button press in csh_box.
function csh_box_Callback(hObject, eventdata, handles)
% hObject    handle to csh_box (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.non_ideal_mode(2) = get(hObject, 'Value');
guidata(hObject, handles)
% Hint: get(hObject,'Value') returns toggle state of csh_box


% --- Executes on button press in pd_box.
function pd_box_Callback(hObject, eventdata, handles)
% hObject    handle to pd_box (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.non_ideal_mode(3) = get(hObject, 'Value');
guidata(hObject, handles)
% Hint: get(hObject,'Value') returns toggle state of pd_box


% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% handles.slider1.Min = floor(handles.thickness / 2) / 180;
% handles.slider1.Max = 1 - floor(handles.thickness / 2) / 180;
handles.curr_slice = get(hObject, 'Value');
handles.slice_text.String = floor(handles.curr_slice * 180) + 1;
guidata(hObject, handles)
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in mm1_button.
function mm1_button_Callback(hObject, eventdata, handles)
% hObject    handle to mm1_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if get(hObject,'Value') == 1
    handles.thickness = 1;
    handles.slider1.Min = floor(handles.thickness / 2) / 180;
    handles.slider1.Max = 1 - floor(handles.thickness / 2) / 180;
    handles.slider1.Value = 0.5;
    handles.curr_slice = 0.5;
    handles.slice_text.String = "90";
end
guidata(hObject, handles)
% Hint: get(hObject,'Value') returns toggle state of mm1_button


% --- Executes on button press in mm3_button.
function mm3_button_Callback(hObject, eventdata, handles)
% hObject    handle to mm3_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if get(hObject,'Value') == 1
    handles.thickness = 3;
    handles.slider1.Min = floor(handles.thickness / 2) / 180;
    handles.slider1.Max = 1 - floor(handles.thickness / 2) / 180;
    handles.slider1.Value = 0.5;
    handles.curr_slice = 0.5;
    handles.slice_text.String = "90";
end
guidata(hObject, handles)
% Hint: get(hObject,'Value') returns toggle state of mm3_button


% --- Executes on button press in mm5_button.
function mm5_button_Callback(hObject, eventdata, handles)
% hObject    handle to mm5_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if get(hObject,'Value') == 1
    handles.thickness = 5;
    handles.slider1.Min = floor(handles.thickness / 2) / 180;
    handles.slider1.Max = 1 - floor(handles.thickness / 2) / 180;
    handles.slider1.Value = 0.5;
    handles.curr_slice = 0.5;
    handles.slice_text.String = "90";
end
guidata(hObject, handles)
% Hint: get(hObject,'Value') returns toggle state of mm5_button


% --- Executes on button press in mm7_button.
function mm7_button_Callback(hObject, eventdata, handles)
% hObject    handle to mm7_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if get(hObject,'Value') == 1
    handles.thickness = 7;
    handles.slider1.Min = floor(handles.thickness / 2) / 180;
    handles.slider1.Max = 1 - floor(handles.thickness / 2) / 180;
    handles.slider1.Value = 0.5;
    handles.curr_slice = 0.5;
    handles.slice_text.String = "90";
end
guidata(hObject, handles)
% Hint: get(hObject,'Value') returns toggle state of mm7_button


% --- Executes on button press in noise_box.
function noise_box_Callback(hObject, eventdata, handles)
% hObject    handle to noise_box (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of noise_box

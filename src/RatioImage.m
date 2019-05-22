function varargout = RatioImage(varargin)
% RATIOIMAGE MATLAB code for RatioImage.fig
%      RATIOIMAGE, by itself, creates a new RATIOIMAGE or raises the existing
%      singleton*.
%
%      H = RATIOIMAGE returns the handle to a new RATIOIMAGE or the handle to
%      the existing singleton*.
%
%      RATIOIMAGE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in RATIOIMAGE.M with the given input arguments.
%
%      RATIOIMAGE('Property','Value',...) creates a new RATIOIMAGE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before RatioImage_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to RatioImage_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help RatioImage

% Last Modified by GUIDE v2.5 26-Jul-2014 12:52:39

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @RatioImage_OpeningFcn, ...
                   'gui_OutputFcn',  @RatioImage_OutputFcn, ...
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


% --- Executes just before RatioImage is made visible.
function RatioImage_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to RatioImage (see VARARGIN)

% Choose default command line output for RatioImage
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes RatioImage wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = RatioImage_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in choosenum.
function choosenum_Callback(hObject, eventdata, handles)
% hObject    handle to choosenum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filenum,pathnum] = uigetfile('*.tif','Choose Numerator Image');
imgnum = imread([pathnum filenum]);
setappdata(handles.choosenum,'imgdata',imgnum);
set(handles.numfileshow,'String',[pathnum filenum])

if isappdata(handles.choosedenom,'imgdata')
    imgdenom = getappdata(handles.choosedenom,'imgdata');

    if size(imgnum) == size(imgdenom)
        imgratio = double(imgnum)./double(imgdenom);

        ratiolist = imgratio(:); ratiolist(ratiolist == inf) = 0;
        meanratio = mean(ratiolist); stdratio = std(ratiolist);
        maxratio = meanratio + 2*stdratio;

        set(handles.minratioslider,'Min',min(imgratio(:)));
        set(handles.minratioslider,'Max',maxratio);
        set(handles.minratioslider,'Value',min(imgratio(:)));
        minratio = get(handles.minratioslider,'Value');
        set(handles.minratiodisp,'String',num2str(minratio));


        set(handles.maxratioslider,'Min',min(imgratio(:)));
        set(handles.maxratioslider,'Max',maxratio);   
        set(handles.maxratioslider,'Value',maxratio);
        set(handles.maxratiodisp,'String',num2str(maxratio));

        set(handles.minintslider,'Min',min(imgdenom(:)));
        set(handles.minintslider,'Max',max(imgdenom(:)));
        set(handles.minintslider,'Value',min(imgdenom(:)));
        minint = get(handles.minintslider,'Value');
        set(handles.minintdisp,'String',num2str(minint));

        set(handles.maxintslider,'Min',min(imgdenom(:)));
        set(handles.maxintslider,'Max',max(imgdenom(:)));   
        set(handles.maxintslider,'Value',max(imgdenom(:)));
        maxint = get(handles.maxintslider,'Value');
        set(handles.maxintdisp,'String',num2str(maxint));

        maplist = get(handles.mapchoose,'String');
        mapval = get(handles.mapchoose,'Value');
        map = cell2mat(maplist(mapval));

        imdimage = ratioimd(imgnum,imgdenom,minratio,maxratio,minint,maxint,map);
        axes(handles.axes1);
        imshow(imdimage); colorbar('SouthOutside','XTickLabel',{' '})
        setappdata(handles.axes1,'imgdata',imdimage)
    else
        warning('Images are not the same size')
    end
end


% --- Executes on button press in choosedenom.
function choosedenom_Callback(hObject, eventdata, handles)
% hObject    handle to choosedenom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filedenom,pathdenom] = uigetfile('*.tif','Choose Denominator Image');
imgdenom = imread([pathdenom filedenom]);
setappdata(handles.choosedenom,'imgdata',imgdenom);
set(handles.denomfileshow,'String',[pathdenom filedenom])

if isappdata(handles.choosenum,'imgdata')
    imgnum = getappdata(handles.choosenum,'imgdata');
    if size(imgnum) == size(imgdenom)
        imgratio = double(imgnum)./double(imgdenom);

        ratiolist = imgratio(:); ratiolist(ratiolist == inf) = 0;
        ratiolist(isnan(ratiolist)) = 0;
        meanratio = mean(ratiolist); stdratio = std(ratiolist);
        maxratio = meanratio + 2*stdratio;

        set(handles.minratioslider,'Min',min(imgratio(:)));
        set(handles.minratioslider,'Max',maxratio);
        set(handles.minratioslider,'Value',min(imgratio(:)));
        minratio = get(handles.minratioslider,'Value');
        set(handles.minratiodisp,'String',num2str(minratio));


        set(handles.maxratioslider,'Min',min(imgratio(:)));
        set(handles.maxratioslider,'Max',maxratio);   
        set(handles.maxratioslider,'Value',maxratio);
        set(handles.maxratiodisp,'String',num2str(maxratio));

        set(handles.minintslider,'Min',min(imgdenom(:)));
        set(handles.minintslider,'Max',max(imgdenom(:)));
        set(handles.minintslider,'Value',min(imgdenom(:)));
        minint = get(handles.minintslider,'Value');
        set(handles.minintdisp,'String',num2str(minint));

        set(handles.maxintslider,'Min',min(imgdenom(:)));
        set(handles.maxintslider,'Max',max(imgdenom(:)));   
        set(handles.maxintslider,'Value',max(imgdenom(:)));
        maxint = get(handles.maxintslider,'Value');
        set(handles.maxintdisp,'String',num2str(maxint));

        maplist = get(handles.mapchoose,'String');
        mapval = get(handles.mapchoose,'Value');
        map = cell2mat(maplist(mapval));

        imdimage = ratioimd(imgnum,imgdenom,minratio,maxratio,minint,maxint,map);
        axes(handles.axes1);
        imshow(imdimage); colorbar('SouthOutside','XTickLabel',{' '})
        setappdata(handles.axes1,'imgdata',imdimage)
    else
        warning('Images are not the same size!')
    end
end

% --- Executes on slider movement.
function minintslider_Callback(hObject, eventdata, handles)
% hObject    handle to minintslider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

minint = get(handles.minintslider,'Value');
set(handles.maxintslider,'Min',minint);
if minint > get(handles.maxintslider,'Value')
    set(handles.maxintslider,'Value',minint)
end
maxint = get(handles.maxintslider,'Value');

set(handles.minintdisp,'String',num2str(round(minint)))
set(handles.maxintdisp,'String',num2str(round(maxint)))

imgnum = getappdata(handles.choosenum,'imgdata');
imgdenom = getappdata(handles.choosedenom,'imgdata');
minratio = get(handles.minratioslider,'Value');
maxratio = get(handles.maxratioslider,'Value');
maplist = get(handles.mapchoose,'String');
mapval = get(handles.mapchoose,'Value');
map = cell2mat(maplist(mapval));
imdimage = ratioimd(imgnum,imgdenom,minratio,maxratio,minint,maxint,map);
axes(handles.axes1);
imshow(imdimage); colorbar('SouthOutside','XTickLabel',{' '})
setappdata(handles.axes1,'imgdata',imdimage)


% --- Executes during object creation, after setting all properties.
function minintslider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to minintslider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function maxintslider_Callback(hObject, eventdata, handles)
% hObject    handle to maxintslider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

maxint = get(handles.maxintslider,'Value');
set(handles.minintslider,'Max',maxint);
if maxint < get(handles.minintslider,'Value')
    set(handles.minintslider,'Value',maxint)
end
minint = get(handles.minintslider,'Value');

set(handles.minintdisp,'String',num2str(round(minint)))
set(handles.maxintdisp,'String',num2str(round(maxint)))

imgnum = getappdata(handles.choosenum,'imgdata');
imgdenom = getappdata(handles.choosedenom,'imgdata');
minratio = get(handles.minratioslider,'Value');
maxratio = get(handles.maxratioslider,'Value');
maplist = get(handles.mapchoose,'String');
mapval = get(handles.mapchoose,'Value');
map = cell2mat(maplist(mapval));
imdimage = ratioimd(imgnum,imgdenom,minratio,maxratio,minint,maxint,map);
axes(handles.axes1);
imshow(imdimage); colorbar('SouthOutside','XTickLabel',{' '})
setappdata(handles.axes1,'imgdata',imdimage)


% --- Executes during object creation, after setting all properties.
function maxintslider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to maxintslider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function maxratioslider_Callback(hObject, eventdata, handles)
% hObject    handle to maxratioslider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

maxratio = get(handles.maxratioslider,'Value');
set(handles.minratioslider,'Max',maxratio);
if maxratio < get(handles.minratioslider,'Value')
    set(handles.minratioslider,'Value',maxratio)
end
minratio = get(handles.minratioslider,'Value');

set(handles.minratiodisp,'String',num2str(minratio))
set(handles.maxratiodisp,'String',num2str(maxratio))

imgnum = getappdata(handles.choosenum,'imgdata');
imgdenom = getappdata(handles.choosedenom,'imgdata');
minint = get(handles.minintslider,'Value');
maxint = get(handles.maxintslider,'Value');
maplist = get(handles.mapchoose,'String');
mapval = get(handles.mapchoose,'Value');
map = cell2mat(maplist(mapval));
imdimage = ratioimd(imgnum,imgdenom,minratio,maxratio,minint,maxint,map);
axes(handles.axes1);
imshow(imdimage); colorbar('SouthOutside','XTickLabel',{' '})
setappdata(handles.axes1,'imgdata',imdimage)



% --- Executes during object creation, after setting all properties.
function maxratioslider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to maxratioslider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function minratioslider_Callback(hObject, eventdata, handles)
% hObject    handle to minratioslider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

minratio = get(handles.minratioslider,'Value');
set(handles.maxratioslider,'Min',minratio);
if minratio > get(handles.maxratioslider,'Value')
    set(handles.maxratioslider,'Value',minratio)
end
maxratio = get(handles.maxratioslider,'Value');

set(handles.minratiodisp,'String',num2str(minratio))
set(handles.maxratiodisp,'String',num2str(maxratio))

imgnum = getappdata(handles.choosenum,'imgdata');
imgdenom = getappdata(handles.choosedenom,'imgdata');
minint = get(handles.minintslider,'Value');
maxint = get(handles.maxintslider,'Value');
maplist = get(handles.mapchoose,'String');
mapval = get(handles.mapchoose,'Value');
map = cell2mat(maplist(mapval));
imdimage = ratioimd(imgnum,imgdenom,minratio,maxratio,minint,maxint,map);
axes(handles.axes1);
imshow(imdimage); colorbar('SouthOutside','XTickLabel',{' '})
setappdata(handles.axes1,'imgdata',imdimage)


% --- Executes during object creation, after setting all properties.
function minratioslider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to minratioslider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in saveastiff.
function saveastiff_Callback(hObject, eventdata, handles)
% hObject    handle to saveastiff (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
imdimage = getappdata(handles.axes1,'imgdata');
[filesave,pathsave] = uiputfile('*.tif','Save File As...');
imwrite(imdimage,[pathsave filesave]);


% --- Executes on selection change in mapchoose.
function mapchoose_Callback(hObject, eventdata, handles)
% hObject    handle to mapchoose (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns mapchoose contents as cell array
%        contents{get(hObject,'Value')} returns selected item from mapchoose

imgnum = getappdata(handles.choosenum,'imgdata');
imgdenom = getappdata(handles.choosedenom,'imgdata');
minint = get(handles.minintslider,'Value');
maxint = get(handles.maxintslider,'Value');
minratio = get(handles.minratioslider,'Value');
maxratio = get(handles.maxratioslider,'Value');
maplist = get(handles.mapchoose,'String');
mapval = get(handles.mapchoose,'Value');
map = cell2mat(maplist(mapval));
imdimage = ratioimd(imgnum,imgdenom,minratio,maxratio,minint,maxint,map);
axes(handles.axes1);
imshow(imdimage); colorbar('SouthOutside','XTickLabel',{' '})
setappdata(handles.axes1,'imgdata',imdimage)


% --- Executes during object creation, after setting all properties.
function mapchoose_CreateFcn(hObject, eventdata, handles)
% hObject    handle to mapchoose (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

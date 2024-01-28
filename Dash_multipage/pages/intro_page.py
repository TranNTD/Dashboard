import dash
from dash import Dash, html, dash_table, dcc, callback, Output, Input
from PIL import Image
import os
from pages.Data_bank import *
dash.register_page(__name__, path='/', name="Introduction")

complaint_img = Image.open("Dash_multipage/pages/assets/UML_complaint.png")
weather_img = Image.open("Dash_multipage/pages/assets/UML_weather.png")

# Define available tables
available_complaint_tables = ['Case', 'failplace', 'car', 'dealer', 'complaintid', 'equipment', 'childseat', 'tire', 'vehicle']
available_weather_tables =  ['weather', 'states', 'us_station']

# Dropdown for selecting tables
table_dropdown_complaint = html.Div([
    html.Label("Complaint's Datatable"),
    dcc.Dropdown(
        options=[{'label': table, 'value': table} for table in available_complaint_tables],
        value='Case',
        id='dropdown_Complaint'
    ),
])

table_dropdown_weather = html.Div([
    html.Label("Weather's Datatable"),
    dcc.Dropdown(
        options=[{'label': table, 'value':table} for table in available_weather_tables]
        ,value='weather'
        ,id = 'dropdown_Weather'
    ),
])


# DataTable to display selected table
final_complaint_table = html.Div([dash_table.DataTable(id="final_Complaint"
        , style_cell={
        'overflow': 'hidden',
        'textOverflow': 'ellipsis',
        'maxWidth': 0,
    }
        ,tooltip_data=None
        ,tooltip_duration=None
        ,style_table={'overflowX': 'auto'}
        ,page_action="native"
        ,page_current= 0
        ,page_size= 10
    ,)])

final_weather_table = html.Div([dash_table.DataTable(id="final_Weather"
        , style_cell={
        'overflow': 'hidden',
        'textOverflow': 'ellipsis',
        'maxWidth': 0,
    }
        ,tooltip_data=None
        ,tooltip_duration=None
        ,style_table={'overflowX': 'auto'}
        ,page_action="native"
        ,page_current= 0
        ,page_size= 10
    ,)])


layout = html.Div(
    children=[
        html.Div([
            html.H2("Complaint Dataset Overview")
            , html.Img(src=complaint_img)
            , table_dropdown_complaint
            , dcc.Loading(id = 'loading_intro-1',children=final_complaint_table, type='circle')
        ])
        , html.Div([
            html.Br(),
            html.H2("Weather Dataset Overview")
            , html.Img(src = weather_img)
            , table_dropdown_weather
            , dcc.Loading(id = 'loading_intro-2',children=final_weather_table, type = 'circle')
        ])
    ]
)

@callback(
    Output(component_id='final_Complaint', component_property='columns'),
    Output(component_id='final_Complaint', component_property='data'),
    Output(component_id='final_Complaint', component_property='tooltip_data'),
    [Input(component_id='dropdown_Complaint', component_property='value')]
)

def update_complaint_table(table_chosen:str):
    df = call_table(table_name=table_chosen, limit_rows=20, text_queries=None)
    
    # Get columns dynamically
    columns = [{'name': col, 'id': col} for col in df.columns]
    
    # Get tooltip_data dynamically
    tooltip_data = [
        {
            column: {'value': str(value), 'type': 'markdown'}
            for column, value in row.items()
        } for row in df.to_dict('rows')
    ]
    return columns, df.to_dict('records'),tooltip_data

@callback(
    Output(component_id='final_Weather', component_property='columns'),
    Output(component_id='final_Weather', component_property='data'),
    Output(component_id='final_Weather', component_property='tooltip_data'),
    [Input(component_id='dropdown_Weather', component_property='value')]
)

def update_weather_table(table_chosen:str):
    df = call_table(table_name=table_chosen, limit_rows=20, text_queries=None)
    
    # Get columns dynamically
    columns = [{'name': col, 'id': col} for col in df.columns]
    
    # Get tooltip_data dynamically
    tooltip_data = [
        {
            column: {'value': str(value), 'type': 'markdown'}
            for column, value in row.items()
        } for row in df.to_dict('rows')
    ]
    return columns, df.to_dict('records'),tooltip_data

if __name__ == '__main__':
    # print('basename:    ', os.path.basename(__file__))
    # print('dirname:     ', os.path.dirname(__file__))
    print(os.listdir("Dash_multipage/pages/assets"))
    
import dash
from dash import Dash, html, dash_table, dcc, callback, Output, Input
from PIL import Image
import os
import sys, os
try:
    from pages.Data_bank import *
except:
    from Data_bank import *


import plotly.express as px

dash.register_page(__name__, path='/analyse', name="Analyse")
########## component Input
checklist_deaths_injured = dcc.Checklist(
    id='checklist_deaths_injured',
    options=[
        {'label': 'Crash', 'value': 'crash'},
        {'label': 'Fire', 'value': 'fire'}
    ],
    value=['crash'],  # Default selected values
)

slider_year_model = dcc.Slider (
    id = 'slider_year_model'
    ,step=None
    ,marks={
        1950 : '1950',
        1960 : '1960',
        1970 : '1970',
        1980 : '1980',
        1990 : '1990',
        2000 : '2000',
        2010 : '2010',
        2020 : '2020'
    }
    ,value = 1990
)

######### component Output

deaths_injured_query = """
        SELECT EXTRACT(YEAR FROM (faildate)) AS year,
	SUM(deaths) AS death_count,
	SUM(injured) AS injured_count,
	SUM(CAST(fire AS INT)) as fire_count,
	SUM(CAST(crash AS INT)) as crash_count
    FROM
        "Case"
    
    GROUP BY
        year
    ORDER BY
        year;
        """
deaths_injured_df= call_table(text_queries=deaths_injured_query)
deaths_injured_table = html.Div(children=[html.H2("Deaths and Injured by year")
                                        ,dash_table.DataTable(deaths_injured_df.to_dict('records')
                                                               ,page_action="native"
                                                                ,page_current= 0
                                                                ,page_size= 10)])
deaths_injured_graph = px.bar(deaths_injured_df, x="year", y=["death_count", "injured_count"], title="Number of Deaths and Injured")
deaths_injured_graph = html.Div(children=[dcc.Graph(figure=deaths_injured_graph)])
                                    
car_model_table = html.Div(children=[html.H2("Most reported Car Brand")
    ,dash_table.DataTable(id="car_model_table"
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
                                                          )])   

car_model_graph = html.Div(children=[dcc.Graph(id="car_model_fig")])
case_count_by_state = """
        select sal."STATE",states.name, sal.avg_lat, sal.avg_lon, ccs.case_count
        from 
        state_avg_location sal JOIN case_count_by_state ccs ON sal."STATE" = ccs."STATE"
					          JOIN states on sal."STATE" = states.id;
        """
case_count_by_state_df = call_table(text_queries=case_count_by_state)
case_count_by_state_df_dict = case_count_by_state_df.to_dict("records")
fail_place_fig = px.scatter_mapbox(case_count_by_state_df, lat = "avg_lat", lon="avg_lon", color = "case_count", size = "case_count", hover_name="name", size_max=50, zoom=2)#, center={"lat":39.381266, "lon": -97.922211})#, scope = "usa") #
fail_place_fig.update_layout(mapbox_style="open-street-map")
fail_place_fig.update_layout(margin={"r":0,"t":0,"l":0,"b":0}) 
fail_place_fig_div = html.Div(children=[html.H2("Reported States"),
                                        dcc.Graph(figure=fail_place_fig)]) 


layout = html.Div(
    children=[
        dcc.Tabs(children =[
            dcc.Tab(label="Deaths & Injured", children=[
                                                        dcc.Loading(id = 'loading-1', children=[deaths_injured_table], type="circle")
                                                        ,dcc.Loading(id = 'loading-2', children=[deaths_injured_graph], type="circle")
                                                        ]
                                                        )
            , dcc.Tab(label="Car Model", children=[slider_year_model
                                                   ,dcc.Loading(id = 'loading-3', children=[car_model_table], type='circle')
                                                   , dcc.Loading(id = 'loading-4', children=[car_model_graph], type='circle')

            ])
            , dcc.Tab(label="Fail Place", children=[html.Br()
                                                    ,fail_place_fig_div])
           ]                                             
        )
    ]
)


@callback(
    Output(component_id="car_model_table", component_property="data")
    ,Output(component_id="car_model_fig", component_property="figure")
    ,[Input(component_id='slider_year_model', component_property='value')]
)
def update_car_model(chosen_year):
    query="""   
        SELECT COUNT(*) AS amount, maketxt 
        FROM car
        WHERE yeartxt < {}
        GROUP BY maketxt
        ORDER BY amount DESC limit 10
    ;""".format(int(chosen_year))
    
    maketxt_df = call_table(text_queries=query)
    fig = px.histogram(maketxt_df, x='maketxt', y='amount', title = "TOP 10 most reported Car brands from {} to {}". format('1940',chosen_year))
    return maketxt_df.to_dict("records"), fig

if __name__ == '__main__':
   fail_place_fig.show()


select *
  from public.cyclosm_ways
 where type ='cycleway'
             and 
            (bicycle not in ('no','use_sidepath','delivery','permit','permissive','destination','mtb','military','dismount','customers','undefined','discouraged','no|designated','unknown') or bicycle is null)
			 and 
            (cycleway_left_render is null 
             and  
		     cycleway_right_render is null )
			 
union

select *
  from public.cyclosm_ways
 where segregated ='yes'
        and 
        (cycleway_left_render is null 
        and  
		cycleway_right_render is null )
		and 
		type not in ('cycleway')

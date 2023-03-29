select *
  from public.cyclosm_ways
 where  cycleway_left_render in ('lane','busway','track','sidewalk')
        or  
		cycleway_right_render in ('lane','busway','track','sidewalk') 
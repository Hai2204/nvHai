/* NPMOCVF */
/* LAUCVF -- LAUC -- NPMOCVF (Drop Tail) -- NPMOC 
 *
 */
#include "lauc-scheduler.h"
#include "fdl-scheduler.h"

/* alloc method */
/* GMG -- added parent (pointer to base classifier for node of
 *        this schedulerf
 */
void LaucScheduler::alloc( u_int ncc, u_int ndc, u_int maxChannels,
                     BaseClassifier *parent ) {
    assert( ( ncc > 0 ) && ( ndc > 0 ) && ( maxChannels > 0 ) );
    assert( (ncc + ndc) == maxChannels );

    ncc_ = ncc;
    ndc_ = ndc;
    maxChannels_ = maxChannels;
    bc_ = parent;

    unschTime_ = new double[maxChannels];
    startTime_ = new double[maxChannels];
    endTime_ = new double[maxChannels];

    memset( unschTime_, 0, maxChannels * sizeof( double ) );
    memset( startTime_, 0, maxChannels * sizeof( double ) );
    memset( endTime_, 0, maxChannels * sizeof( double )  );
}


double LaucScheduler::duration( u_int pktsize ) {
            if( pktsize > 0 )
//               return (8. * pktsize / ( 1.*  ( chbw_ * maxChannels_ )) );
// GMG -- removed maxChannels from above (packet is transmitted on one channel)
                return (8. * pktsize / ( 1.*  chbw_) );
            else {
                Debug::debug( __FILE__, __LINE__, "Critical error: provided packet's size is <0" );
                exit (-1);
            }
        }

/* Schedule a control channel at the proposed schedule time and duration */
Schedule LaucScheduler::schedControl( double schedTime, double schedDur ) {
    //cout<<"LaucScheduler::schedControl(schedTime:"<<schedTime<<",schedDur:"<<schedDur<<")"<<endl;
	Schedule result;
    double diffTime = HUGE_VAL;	
    assert( ( schedTime >= 0. ) && ( schedDur >= 0. ) );
    assert( ( ncc_ > 0 ) && ( ndc_ > 0 ) && ( ( ncc_ + ndc_ ) == maxChannels_ ) );
	
	/*
	*/
	//#BEGIN LAUC, 
	//cout << "LAUC:schedControl"<<endl;
    for( u_int i = 0; i < ncc_; i++ ){
        if( schedTime >= unschTime_[i] )
        if( ( schedTime - unschTime_[i] ) < diffTime ) {
            diffTime = schedTime - unschTime_[i];
            result.channel() = i;
            result.startTime() = schedTime;
        }
    }
    int ch = result.channel();

    if( ch >= 0 )
        unschTime_[ch] = schedTime + schedDur;
	//cout << "LAUC:schedControl - END"<<endl;
	/**/
    return result;
}


/* Schedule a data channel at the proposed schedule time and duration */
Schedule LaucScheduler::schedData( double schedTime, double schedDur, int &fdl_count ){
	//cout<<endl;
	//cout<<"LaucScheduler::schedData(schedTime:"<<schedTime<<",schedDur:"<<schedDur<<")"<<endl;
    int count = fdl_count;  //GMG -- added FDL count to arg list and local variable

    // make sure the sched duration is greater than 0.
    assert( ( schedTime >= 0. ) && ( schedDur > 0. ) );
    assert( ( ncc_ > 0 ) && ( ndc_ > 0 ) && ( ( ncc_ + ndc_ ) == maxChannels_ ) );

    bc_->FS_.FdlSchedSave();  //GMG -- added saving of state of FDL scheduler
	
    Schedule result = search( schedTime, schedDur, count );
    fdl_count = count;  //GMG -- added update of count of #FDLs used

    int ch = result.channel();
    if( ch >= 0 )
        update( ch, result.startTime(), schedDur );

    return result;
}

//Tim kiem kenh lap lich
// search the scheduler and the voids for an appropriate schedule
/*
schedTime: Thoi gian den cua chum Chua lap lich
schedDur: Do dai cua chum chua lap lich
*/
Schedule LaucScheduler::search( double schedTime, double schedDur, int &count ) {
	//cout<<"LaucScheduler::search(schedTime:"<<schedTime<<",schedDur:"<<schedDur<<")"<<endl;
    Schedule result;    
    double   diffTime = HUGE_VAL;
	double	tempGap = HUGE_VAL;
    double	tempOverlap = HUGE_VAL;	
	
	while(1){	
	
		//LAUCVF - Lap lich trong khoang trong
       for( u_int i = ncc_; i < maxChannels_; i++ )
	   {		   
           if( schedTime >= startTime_[i] )//Gap
           if( ( endTime_[i] - schedTime ) >= schedDur )
           if( ( schedTime - startTime_[i] ) < tempGap )//
           {
               tempGap = schedTime - startTime_[i];
               result.channel() = i;
               result.startTime() = schedTime;
           }       
	   }	  
	   if (result.channel() >= 0)  //GMG added -- Channel found
	   {		
		   break;
	   }
		//LAUCVF.end
		
		//LAUC - Lap lich ngoai khoang trong
	   for( u_int i = ncc_; i < maxChannels_; i++ )
       {           		   
           if( schedTime >= unschTime_[i] ) //~ Tub >= LAUTi
           if( ( schedTime - unschTime_[i] ) < tempGap ) //Tim khoang trong nho nhat
           {
               tempGap = schedTime - unschTime_[i];
               result.channel() = i;
               result.startTime() = schedTime;
           }       
	   }	   
	   if (result.channel() >= 0)  //GMG added -- Channel found
	   {		   
		   break;
	   }
		//LAUC.end
		
		//NPMOC-VF, Drop Tail
		tempOverlap = HUGE_VAL;
		for( u_int i = ncc_; i < maxChannels_; i++ )
			if((schedTime > startTime_[i]) && ((schedTime + schedDur) > endTime_[i]))
			if(((schedTime + schedDur)-endTime_[i])<tempOverlap)	//		
			{
				tempOverlap = (schedTime + schedDur) - endTime_[i];//Drop Tail			
				result.channel() = i;				
			}
		if (result.channel() >= 0)
		{
			schedTime=schedTime-tempOverlap;
			schedDur=schedDur-tempOverlap;	
			result.startTime() = schedTime;		
			break;
		}
		//NPMOC-VF.end
		
		//NPMOC, Drop Tail
		for( u_int i = ncc_; i < maxChannels_; i++ )
			if(schedTime + schedDur > unschTime_[i])
			if ((unschTime_[i]-schedTime)< tempOverlap)//       
			{
			   tempOverlap =  unschTime_[i] - schedTime;
			   result.channel() = i;               
			} 		
		if (result.channel() >= 0)  //GMG added -- Channel found
		{
			schedTime=schedTime-tempOverlap;
			schedDur=schedDur-tempOverlap;
			result.startTime() = schedTime;			
			break;	
		}		
		break;
		//NPMOC.end
		
		
		
		
		break;
	}
    
    return (result);
}

// update the $channel information
void LaucScheduler::update( u_int channel, double schedTime, double schedDur )
{
    //cout<<"LaucScheduler::update(channel:"<<channel<<",schedTime:"<<schedTime<<",schedDur:"<<schedDur<<")"<<endl;
	if(schedTime == unschTime_[channel]) //GMG --if the new burst
                                         //immediately
                                         //follows the latest current
                                         //burst, there is no new void
    // (used if a burst is held in an elect buffer until the earliest
    // unscheduled time)
       unschTime_[channel] = schedTime + schedDur;
    else if( schedTime > unschTime_[channel] ) {
        startTime_[channel] = unschTime_[channel];
        unschTime_[channel] = schedTime + schedDur;
        endTime_[channel] = schedTime;
    } else {
        // scheduled in the void
        // i.e sched_time < unsch_time[channel]
        startTime_[channel] = schedTime + schedDur;
    }
}



/* Diagnostic method */
void LaucScheduler::printChInfo( u_int channel ) {
	//cout<<"LaucScheduler::printChInfo(channel:"<<channel<<")"<<endl;
    assert( channel < maxChannels_ );

    cout << "Channel " << channel << " unscheduled time: " <<
         unschTime_[channel] << " start time: " << startTime_[channel] <<
         " end time: " << endTime_[channel] << endl;
}


BEGIN{
}
{
if($6 == "cwnd_")         #/*dont leave space after writting cwnd */
printf("%f\t%f\t\n",$1,$7);
}	
END{
}


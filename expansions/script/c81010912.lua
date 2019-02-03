--Answer·福山舞
function c81010912.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,c81010912.ffilter,2,true)
end
function c81010912.ffilter(c,fc,sub,mg,sg)
	return c:IsFusionType(TYPE_MONSTER) and (not sg or sg:FilterCount(aux.TRUE,c)==0 or sg:IsExists(Card.IsFusionCode,1,c,c:GetFusionCode()))
end

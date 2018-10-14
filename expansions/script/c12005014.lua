--反击的天使 丘依儿
function c12005014.initial_effect(c)
	--draw or Destroy
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_CHAIN_SOLVED)
	e5:SetRange(LOCATION_HAND)
	e5:SetOperation(c12005014.drop)
	c:RegisterEffect(e5)
	--activate from hand
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(aux.TargetBoolFunction(c12005014.mfilter))
	e1:SetTargetRange(LOCATION_HAND,0)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	c:RegisterEffect(e2)
end
function c12005014.mfilter(c,g)
	return c:IsSetCard(0xfbb) or c:IsSetCard(0xfb0) or c:IsSetCard(0xfbe)
end
function c12005014.desfilter(c,g)
	return g:IsContains(c) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c12005014.drop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=re:GetHandler()
	local cg=Duel.GetMatchingGroup(c12005014.desfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,rc:GetColumnGroup())
	if re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_COUNTER) and cg:GetCount()>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) then 
	sel=Duel.SelectOption(tp,aux.Stringid(12005014,3),aux.Stringid(12005014,4))+1
	if sel==1 then
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local tc=Duel.SelectMatchingCard(tp,c12005014.desfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,rc:GetColumnGroup())
	Duel.SendtoHand(tc,nil,REASON_EFFECT)
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
	end
end
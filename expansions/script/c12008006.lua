--双色的恋意
function c12008006.initial_effect(c)
	--recover
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCategory(CATEGORY_RECOVER)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c12008006.cost)
	e1:SetTarget(c12008006.tg)
	e1:SetOperation(c12008006.op)
	c:RegisterEffect(e1)	
end
function c12008006.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local tuc=Duel.GetTurnCount()
	if chk==0 then return Duel.GetFlagEffect(tp,12008106)<tuc*2+2 end
	Duel.RegisterFlagEffect(tp,12008106,RESET_PHASE+PHASE_END,0,1)
end
function c12008006.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(800)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,800)
end
function c12008006.thfilter(c)
	return c:IsType(TYPE_MONSTER) and (c:IsSetCard(0x1fb3) or c:IsSetCard(0xfbb)) and c:IsAbleToHand()
end
function c12008006.op(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if Duel.Recover(p,d,REASON_EFFECT)<=0 then return end
	Duel.BreakEffect()
	local ct=Duel.GetFlagEffect(tp,12008006)
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
	   Duel.RegisterFlagEffect(tp,12008006,RESET_PHASE+PHASE_END,0,1)
	end
	if ct<=0 then return end
	local g=Duel.GetMatchingGroup(c12008006.thfilter,tp,LOCATION_DECK,0,nil)
	if ct>=1 and g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(12008006,0)) then
	   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	   local tg=g:Select(tp,1,1,nil)
	   Duel.SendtoHand(tg,nil,REASON_EFFECT)
	   Duel.ConfirmCards(1-tp,tg)
	end
	if ct>=2 then
	   Duel.Recover(p,d,REASON_EFFECT)
	end
	local sg=Duel.GetMatchingGroup(c12008006.spfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil,e,tp)
	if ct>=3 and sg:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.SelectYesNo(tp,aux.Stringid(12008006,1)) then
	   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	   local tg=sg:Select(tp,1,1,nil)
	   local ts=tg:GetFirst()
	   if ts and Duel.SpecialSummonStep(ts,0,tp,tp,false,false,POS_FACEUP) then
	   local e1=Effect.CreateEffect(e:GetHandler())
	   e1:SetType(EFFECT_TYPE_SINGLE)
	   e1:SetCode(EFFECT_CANNOT_TRIGGER)
	   e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	   ts:RegisterEffect(e1)
	   end
	   Duel.SpecialSummonComplete()
	end
	local dg=Duel.GetMatchingGroup(c12008006.thfilter2,tp,LOCATION_DECK,0,nil)
	if ct>=4 and dg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(12008006,2)) then
	   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	   local tg=dg:Select(tp,1,1,nil)
	   Duel.SendtoHand(tg,nil,REASON_EFFECT)
	   Duel.ConfirmCards(1-tp,tg)
	end 
end
function c12008006.thfilter2(c)
	return c:IsCode(12008006) and c:IsAbleToHand()
end
function c12008006.spfilter(c,e,tp)
	return (c:IsSetCard(0x1fb3) or c:IsSetCard(0xfbb)) and c:IsFaceup() and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end

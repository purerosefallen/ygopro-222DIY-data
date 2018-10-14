--夺宝奇兵·海格尔
function c10140006.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c10140006.spcon)
	c:RegisterEffect(e1) 
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10140006,0))
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,10140006)
	e2:SetTarget(c10140006.destg)
	e2:SetOperation(c10140006.desop)
	c:RegisterEffect(e2)  
end
function c10140006.spfilter(c)
	return (c:IsLocation(LOCATION_HAND) or c:IsFaceup()) and c:IsSetCard(0x6333) and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c10140006.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c10140006.spfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
end
function c10140006.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10140006.spfilter,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,tp,LOCATION_ONFIELD)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,0,tp,LOCATION_DECK)
end
function c10140006.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,c10140006.desfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,nil)
	if g:GetCount()>0 and Duel.Destroy(g,REASON_EFFECT)~=0 then
	   local code=g:GetFirst():GetCode()
	   local tg=Duel.GetMatchingGroup(c10140006.thfilter,tp,LOCATION_DECK,0,nil,code)
	   if tg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(10140006,2)) then
		  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		  local tg2=tg:Select(tp,1,1,nil)
		  Duel.SendtoHand(tg2,nil,REASON_EFFECT)
		  Duel.ConfirmCards(1-tp,tg2)
	   end
	end
end
function c10140006.desfilter(c)
	return c:IsSetCard(0x6333) and (c:IsLocation(LOCATION_HAND) or c:IsFaceup())
end
function c10140006.thfilter(c,code)
	return c:IsCode(code) and c:IsAbleToHand()
end
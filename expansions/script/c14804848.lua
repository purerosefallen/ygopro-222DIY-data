--九尾仙狐
function c14804848.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,c14804848.lcheck,3,3)
	c:EnableReviveLimit()
	c:EnableCounterPermit(0x48f)
	c:SetCounterLimit(0x48f,9)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c14804848.splimit)
	c:RegisterEffect(e1)
	--cannot link material
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--counter
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_COUNTER)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCountLimit(1,148048481)
	e3:SetCondition(c14804848.ctcon)
	e3:SetOperation(c14804848.ctop)
	c:RegisterEffect(e3)
	--add counter
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetCode(EVENT_CHAINING)
	e4:SetRange(LOCATION_MZONE)
	e4:SetOperation(aux.chainreg)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e5:SetCode(EVENT_CHAIN_SOLVING)
	e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetRange(LOCATION_MZONE)
	e5:SetOperation(c14804848.acop)
	c:RegisterEffect(e5)
	--indes
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e6:SetCondition(c14804848.incon3)
	e6:SetValue(1)
	c:RegisterEffect(e6)
	--immune 
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetCode(EFFECT_IMMUNE_EFFECT)
	e7:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCondition(c14804848.incon6)
	e7:SetValue(c14804848.efilter)
	c:RegisterEffect(e7)
	--direct attack 
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_FIELD)
	e8:SetCode(EFFECT_DIRECT_ATTACK)
	e8:SetRange(LOCATION_MZONE)
	e8:SetTargetRange(LOCATION_MZONE,0)
	e8:SetCondition(c14804848.effcon9)
	e8:SetTarget(c14804848.tg)
	c:RegisterEffect(e8)
	--toHand 
	local e9=Effect.CreateEffect(c)
	e9:SetDescription(aux.Stringid(14804848,0))
	e9:SetCategory(CATEGORY_TOHAND)
	e9:SetType(EFFECT_TYPE_IGNITION)
	e9:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e9:SetRange(LOCATION_MZONE)
	e9:SetCountLimit(1,14804848)
	e9:SetCost(c14804848.thcost)
	e9:SetTarget(c14804848.thtg)
	e9:SetOperation(c14804848.thop)
	c:RegisterEffect(e9)
	--special summon 
	local e10=Effect.CreateEffect(c)
	e10:SetDescription(aux.Stringid(14804848,1))
	e10:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e10:SetType(EFFECT_TYPE_IGNITION)
	e10:SetRange(LOCATION_MZONE)
	e10:SetCountLimit(1,14804848)
	e10:SetCost(c14804848.spcost)
	e10:SetTarget(c14804848.sptg)
	e10:SetOperation(c14804848.spop)
	c:RegisterEffect(e10)
	--remove 
    local e11=Effect.CreateEffect(c)
    e11:SetDescription(aux.Stringid(14804848,2))
    e11:SetCategory(CATEGORY_TOGRAVE)
    e11:SetType(EFFECT_TYPE_QUICK_O)
    e11:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e11:SetCode(EVENT_FREE_CHAIN)
    e11:SetRange(LOCATION_MZONE)
    e11:SetCountLimit(1,14804848)
	e11:SetCondition(c14804848.rmcon)
    e11:SetCost(c14804848.rmcost)
    e11:SetTarget(c14804848.rmtg)
    e11:SetOperation(c14804848.rmop)
    c:RegisterEffect(e11)
end
function c14804848.splimit(e,se,sp,st)
	return (st & SUMMON_TYPE_LINK)==SUMMON_TYPE_LINK
end
function c14804848.lcheck(c)
	return c:IsRace(RACE_BEAST) and c:IsType(TYPE_LINK)
end
function c14804848.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c14804848.ctop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():AddCounter(0x48f,9)
end
function c14804848.acop(e,tp,eg,ep,ev,re,r,rp)
	if re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_SPELL) and e:GetHandler():GetFlagEffect(1)>0 then
		e:GetHandler():AddCounter(0x48f,1)
	end
end
function c14804848.incon3(e)
	return Duel.GetCounter(e:GetHandlerPlayer(),1,0,0x48f)>=3
end
function c14804848.incon6(e)
	return Duel.GetCounter(e:GetHandlerPlayer(),1,0,0x48f)>=6
end
function c14804848.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function c14804848.effilter(c)
	return c:IsFaceup() and c:IsType(TYPE_LINK) and c:IsRace(RACE_BEAST)
end
function c14804848.effcon9(e)
	return Duel.GetCounter(e:GetHandlerPlayer(),1,0,0x48f)>=9 and Duel.GetMatchingGroupCount(c14804848.effilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,nil)>=e:GetLabel()
end
function c14804848.tg(e,c)
	return c:IsType(TYPE_LINK) and c:IsRace(RACE_BEAST)
end
function c14804848.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0x48f,3,REASON_COST) end
	e:GetHandler():RemoveCounter(tp,0x48f,3,REASON_COST)
end
function c14804848.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsAbleToHand() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToHand,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,Card.IsAbleToHand,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c14804848.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
function c14804848.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0x48f,6,REASON_COST) end
	e:GetHandler():RemoveCounter(tp,0x48f,6,REASON_COST)
end
function c14804848.spfilter(c,e,tp)
	return c:IsLevelBelow(3) and c:IsRace(RACE_BEAST) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c14804848.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c14804848.spfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE)
end
function c14804848.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c14804848.spfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c14804848.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return  Duel.GetTurnPlayer()~=tp
end
function c14804848.rmcost(e,tp,eg,ep,ev,re,r,rp,chk)
   if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0x48f,9,REASON_COST) end
	e:GetHandler():RemoveCounter(tp,0x48f,9,REASON_COST)
end
function c14804848.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) end
    local g=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler())
    Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,g:GetCount(),0,0)
end
function c14804848.rmop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler())
    Duel.SendtoGrave(g,REASON_EFFECT)
end
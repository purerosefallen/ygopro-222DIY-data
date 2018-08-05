--新起的虹神 完红的丘依儿
function c12005015.initial_effect(c)
	c:EnableReviveLimit()
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c12005015.splimit)
	c:RegisterEffect(e1)
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c12005015.sprcon)
	e2:SetOperation(c12005015.sprop)
	c:RegisterEffect(e2)
	--tohand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(12005015,0))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(c12005015.thtg)
	e3:SetOperation(c12005015.thop)
	c:RegisterEffect(e3)
	--set
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(12005015,1))
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_MZONE)
	e4:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e4:SetCondition(c12005015.setcon)
	e4:SetCost(c12005015.setcost)
	e4:SetTarget(c12005015.settg)
	e4:SetOperation(c12005015.setop)
	c:RegisterEffect(e4)
end
function c12005015.setcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function c12005015.setcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c12005015.setfilter(c)
	return c:IsSSetable() and c:IsType(TYPE_COUNTER) and c:IsFaceup()
end
function c12005015.settg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local g=Duel.GetMatchingGroup(c12005015.setfilter,tp,LOCATION_REMOVED,0,nil)
	if chk==0 then
		local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
		return ft>2 and g:GetClassCount(Card.GetCode)>2
	end
	local sg=Group.CreateGroup()
	for i=1,3 do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		local g1=g:Select(tp,1,1,nil)
		g:Remove(Card.IsCode,nil,g1:GetFirst():GetCode())
		sg:Merge(g1)
	end
	Duel.SetTargetCard(sg)
end
function c12005015.setop(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	local sg2=Group.CreateGroup()
	if g:GetCount()==0 then return end
	if g:GetCount()<=ft then
	   Duel.SSet(tp,g)
	   sg2:Merge(g)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		local sg=g:Select(tp,ft,ft,nil)
		Duel.SSet(tp,sg)
		g:Sub(sg)
		Duel.SendtoGrave(g,REASON_RULE)
		sg2:Merge(sg)
	end
	for tc in aux.Next(sg2) do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
		e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
	end
end
function c12005015.thfilter(c)
	return c:IsSetCard(0xfbb) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c12005015.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c12005015.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c12005015.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c12005015.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)~=0 then
	   Duel.ConfirmCards(1-tp,g)
		local tc=g:GetFirst()
		if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
		local code=tc:GetCode()
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_ADD_CODE)
		e2:SetValue(code)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e2)
		c:CopyEffect(code,RESET_EVENT+RESETS_STANDARD,1)
	end
end
function c12005015.sprfilter1(c,tp)
	return c:IsAbleToRemoveAsCost() and c:IsType(TYPE_COUNTER) and c:IsSetCard(0xfbb) and Duel.IsExistingMatchingCard(c12005015.sprfilter2,tp,0xc,0,1,nil,tp,c:GetCode())
end
function c12005015.sprfilter2(c,tp,code)
	return c:IsAbleToRemoveAsCost() and c:IsType(TYPE_COUNTER) and c:IsSetCard(0xfbb) and not c:IsCode(code) and Duel.IsExistingMatchingCard(c12005015.sprfilter3,tp,0x10,0,1,nil,c:GetCode(),code)
end
function c12005015.sprfilter3(c,code1,code2)
	return c:IsAbleToRemoveAsCost() and c:IsType(TYPE_COUNTER) and c:IsSetCard(0xfbb) and not c:IsCode(code1,code2)
end
function c12005015.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCountFromEx(tp)>0 and Duel.IsExistingMatchingCard(c12005015.sprfilter1,tp,0x2,0,1,nil,tp)
end
function c12005015.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local tg1=Duel.SelectMatchingCard(tp,c12005015.sprfilter,tp,0x2,0,1,1,nil,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local tg2=Duel.SelectMatchingCard(tp,c12005015.sprfilter,tp,0xc,0,1,1,nil,tp,tg1:GetFirst():GetCode())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local tg3=Duel.SelectMatchingCard(tp,c12005015.sprfilter,tp,0x10,0,1,1,nil,tg1:GetFirst():GetCode(),tg2:GetFirst():GetCode())
	tg1:Merge(tg2)
	tg1:Merge(tg3)
	Duel.Remove(tg1,POS_FACEUP,REASON_COST)
end
function c12005015.splimit(e,se,sp,st)
	return e:GetHandler():GetLocation()~=LOCATION_EXTRA
end
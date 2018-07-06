--神之国度 阿斯加德
local m=10120010
local cm=_G["c"..m]
if not pcall(function() require("expansions/script/c10120001") end) then require("script/c10120001") end
function cm.initial_effect(c)
	dsrsv.DanceSpiritNegateEffect(c,m,CATEGORY_TOHAND,cm.ntg,cm.nop)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--level
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_LEVEL)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_HAND,0)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x9331))
	e2:SetValue(-1)
	c:RegisterEffect(e2) 
	--disable spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,0))
	e3:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCode(EVENT_SPSUMMON)
	e3:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e3:SetCondition(cm.necon)
	e3:SetTarget(cm.netg)
	e3:SetOperation(cm.neop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_SUMMON)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(m,1))
	e5:SetCategory(CATEGORY_NEGATE+CATEGORY_TOHAND)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_CHAINING)
	e5:SetRange(LOCATION_FZONE)
	e5:SetCountLimit(1)
	e5:SetCondition(cm.necon2)
	e5:SetTarget(cm.netg2)
	e5:SetOperation(cm.neop2)
	c:RegisterEffect(e5)
end
function cm.ntg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,tp,e:GetHandler():GetLocation())
end
function cm.nop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
	   Duel.SendtoHand(c,nil,REASON_EFFECT)
	   Duel.ConfirmCards(1-tp,c)
	end
end
function cm.necon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsChainNegatable(ev) and tp==ep and re:GetHandler()~=e:GetHandler()
end
function cm.netg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,eg,0,0,0)
end
function cm.neop2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) then
	   if re:GetHandler():IsRelateToEffect(re) and re:GetHandler():IsAbleToHand() and Duel.SelectYesNo(tp,aux.Stringid(m,2)) then
		  Duel.BreakEffect()
		  Duel.SendtoHand(eg,nil,REASON_EFFECT)
	   end
	end
end
function cm.necon(e,tp,eg,ep,ev,re,r,rp)
	return tp==ep and Duel.GetCurrentChain()==0
end
function cm.netg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,eg,eg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,eg,0,0,0)
end
function cm.neop(e,tp,eg,ep,ev,re,r,rp)
	 Duel.NegateSummon(eg)
	 local ct=eg:FilterCount(Card.IsAbleToHand,nil)
	 if eg:GetCount()==ct and Duel.SelectYesNo(tp,aux.Stringid(m,2)) then
		Duel.BreakEffect()
		Duel.SendtoHand(eg,nil,REASON_EFFECT)
	 end
end

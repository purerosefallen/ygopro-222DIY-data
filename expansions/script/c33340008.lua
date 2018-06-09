--热核污染病毒-ç
if not pcall(function() require("expansions/script/c33340004") end) then require("script/c33340004") end
local m=33340008
local cm=_G["c"..m]
function cm.initial_effect(c)
	rccv.publiceffect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(cm.thtg)
	e1:SetOperation(cm.thop)
	c:RegisterEffect(e1)   
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_SUMMON_PROC)
	e2:SetCondition(cm.ntcon)
	e2:SetOperation(cm.ntop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,4))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetRange(LOCATION_HAND)
	e3:SetCountLimit(1)
	e3:SetCondition(rccv.pubcon)
	e3:SetOperation(cm.thop2)
	c:RegisterEffect(e3) 
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,2))
	e4:SetCategory(CATEGORY_REMOVE)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e4:SetRange(LOCATION_HAND)
	e4:SetCountLimit(1)
	e4:SetCondition(rccv.pubcon)
	e4:SetTarget(cm.rmtg)
	e4:SetOperation(cm.rmop)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e5:SetRange(LOCATION_HAND)
	e5:SetCode(EVENT_PRE_BATTLE_DAMAGE)
	e5:SetCondition(cm.rdcon)
	e5:SetOperation(cm.rdop)
	c:RegisterEffect(e5)
end
cm.setcard="Rcore"
function cm.rdcon(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp and e:GetHandler():IsPublic()
end
function cm.rdop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChangeBattleDamage(tp,ev/2)
end
function cm.thop2(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
	   Duel.SendtoHand(e:GetHandler(),1-tp,REASON_EFFECT)
	end
end
function cm.rfilter(c)
	return c:IsAbleToRemove() and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function cm.rmop(e,tp,eg,ep,ev,re,r,rp)
	local lp=Duel.GetLP(tp)
	if lp<=800 then Duel.SetLP(tp,0) return end
	Duel.SetLP(tp,lp-800)
	local g=Duel.GetMatchingGroup(cm.rfilter,tp,0xc,0,nil)
	if g:GetCount()>0 then
	   Duel.BreakEffect()
	   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	   local rg=g:Select(tp,1,1,nil)
	   Duel.HintSelection(rg)
	   Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)
	end
end
function cm.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,0xc)
end
function cm.ntcon(e,c,minc)
	if c==nil then return true end
	return minc==0 and c:GetLevel()>4 and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end
function cm.ntop(e,tp,eg,ep,ev,re,r,rp,c)
	return true
end
function cm.thfilter(c)
	return c.setcard=="Rcore" and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,0x1,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,0x1)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.thfilter),tp,0x1,0,1,1,nil)
	if g:GetCount()>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)~=0 then
	   Duel.ConfirmCards(1-tp,g)
	   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	   local tg=Duel.SelectMatchingCard(tp,nil,tp,0x2,0,1,1,nil) 
	   Duel.SendtoHand(tg,1-tp,REASON_EFFECT)   
	end
end
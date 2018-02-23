--夜鸦·诱捕者I
if not pcall(function() require("expansions/script/c10114001") end) then require("script/c10114001") end
local m=10114015
local cm=_G["c"..m]
function cm.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x3331),5,2)
	c:EnableReviveLimit()
	nrrsv.NightRavenSpecialSummonRule(c,6,m)
	--wocao
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,1))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1)
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1)   
end
function cm.eqfilter(c,tp)
	if c:IsType(TYPE_MONSTER) then return 
	   (c:IsControler(tp) or c:IsAbleToChangeControler()) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
	else return 
	   c:IsAbleToHand()
	end
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return cm.eqfilter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(cm.eqfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler(),tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,cm.eqfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetHandler(),tp)
	if g:GetFirst():IsType(TYPE_MONSTER) then
	   Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
	else
	   Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
	end
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc,c=Duel.GetFirstTarget(),e:GetHandler()
	if not tc:IsRelateToEffect(e) then return end
	if tc:IsType(TYPE_MONSTER) then
	   if c:IsFacedown() or not c:IsRelateToEffect(e) then Duel.SendtoGrave(tc,REASON_EFFECT) return 
	   end
	   if not Duel.Equip(tp,tc,c,false) then return end
	   tc:RegisterFlagEffect(m,RESET_EVENT+0x1fe0000,0,0)
	   e:SetLabelObject(tc)
	   local e1=Effect.CreateEffect(c)
	   e1:SetType(EFFECT_TYPE_SINGLE)
	   e1:SetProperty(EFFECT_FLAG_COPY_INHERIT+EFFECT_FLAG_OWNER_RELATE)
	   e1:SetCode(EFFECT_EQUIP_LIMIT)
	   e1:SetReset(RESET_EVENT+0x1fe0000)
	   e1:SetValue(cm.eqlimit)
	   tc:RegisterEffect(e1)
	   local e2=Effect.CreateEffect(c)
	   e2:SetType(EFFECT_TYPE_EQUIP)
	   e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_OWNER_RELATE)
	   e2:SetCode(EFFECT_UPDATE_ATTACK)
	   e2:SetReset(RESET_EVENT+0x1fe0000)
	   e2:SetValue(300)
	   tc:RegisterEffect(e2)
	else
	   Duel.SendtoHand(tc,tp,REASON_EFFECT)
	   Duel.ConfirmCards(1-tp,tc)
	end
end
function cm.eqlimit(e,c)
	return e:GetOwner()==c
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end

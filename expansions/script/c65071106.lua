--粉红军备
function c65071106.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c65071106.eqtg)
	e1:SetOperation(c65071106.eqop)
	c:RegisterEffect(e1)
	--Equip limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EQUIP_LIMIT)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--Untargetable
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_EQUIP)
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	--battle indestructable
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_EQUIP)
	e4:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e4:SetValue(1)
	c:RegisterEffect(e4)
	--counter
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_COUNTER)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e5:SetCountLimit(1)
	e5:SetCode(EVENT_PHASE+PHASE_END)
	e5:SetTarget(c65071106.contg)
	e5:SetOperation(c65071106.conop)
	c:RegisterEffect(e5)
	--tograve
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e6:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DAMAGE)
	e6:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e6:SetCode(EVENT_TO_GRAVE)
	e6:SetCondition(c65071106.tgcon)
	e6:SetTarget(c65071106.tgtg)
	e6:SetOperation(c65071106.tgop)
	c:RegisterEffect(e6)
end
function c65071106.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c65071106.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,c,tc)
	end
end

function c65071106.confil(c,e)
	return c:GetCounter(0x10da)==0
end

function c65071106.contg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65071106.confil,tp,LOCATION_ONFIELD,0,1,e:GetHandler(),e) and Duel.IsExistingMatchingCard(c65071106.confil,tp,0,LOCATION_ONFIELD,1,nil,e) end
end

function c65071106.conop(e,tp,eg,ep,ev,re,r,rp)
	if not (Duel.IsExistingMatchingCard(c65071106.confil,tp,LOCATION_ONFIELD,0,1,e:GetHandler(),e) and Duel.IsExistingMatchingCard(c65071106.confil,tp,0,LOCATION_ONFIELD,1,nil,e)) then return end
	local g1=Duel.SelectMatchingCard(tp,c65071106.confil,tp,LOCATION_ONFIELD,0,1,1,e:GetHandler(),e)
	Duel.HintSelection(g1)
	local g2=Duel.SelectMatchingCard(c65071106.confil,tp,0,LOCATION_ONFIELD,1,1,nil,e)
	Duel.HintSelection(g2)
	local tc1=g1:GetFirst()
	local tc2=g1:GetFirst()
	tc1:AddCounter(0x10da,1)
	tc2:AddCounter(0x10da,1)
end

function c65071106.tgcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ec=c:GetPreviousEquipTarget()
	return c:IsReason(REASON_LOST_TARGET) and (ec:IsReason(REASON_BATTLE) or (ec:IsReason(REASON_EFFECT) and rp~=tp))
end
function c65071106.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,PLAYER_ALL,0)
end
function c65071106.tgfil(c,e)
	return c:GetCounter(0x10da)>0 
end
function c65071106.tgop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c65071106.tgfil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,e)
	if g:GetCount()>0 then
		local ct=Duel.SendtoGrave(g,REASON_EFFECT)
		local dam=ct*500 
		Duel.Damage(tp,dam,REASON_EFFECT)
		Duel.Damage(1-tp,dam,REASON_EFFECT)
	end
end
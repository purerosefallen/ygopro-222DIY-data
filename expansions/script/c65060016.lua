--德莱姆的星梦者
function c65060016.initial_effect(c)
	--
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	e0:SetValue(1)
	c:RegisterEffect(e0)
	--confirm
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c65060016.condition)
	e1:SetCost(c65060016.cost)
	e1:SetTarget(c65060016.target)
	e1:SetOperation(c65060016.operation)
	c:RegisterEffect(e1)
	--snowflake
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_TRIGGER)
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,LOCATION_SZONE)
	e2:SetTarget(c65060016.distg)
	e2:SetCondition(c65060016.effcon)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_FLIP_SUMMON)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTargetRange(0,1)
	e3:SetCondition(c65060016.sumcon)
	c:RegisterEffect(e3)
end

function c65060016.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetAttack()<=300
end
function c65060016.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	e1:SetValue(200)
	c:RegisterEffect(e1)
end

function c65060016.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsOnField() and chkc:IsFacedown() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFacedown,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEDOWN)
	Duel.SelectTarget(tp,Card.IsFacedown,tp,0,LOCATION_ONFIELD,1,1,nil)
end
function c65060016.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and tc:IsFacedown() then
		Duel.ConfirmCards(tp,tc)
		if tc:IsType(TYPE_MONSTER) and Duel.IsExistingMatchingCard(c65060016.spfil,tp,LOCATION_HAND,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
			if Duel.SelectYesNo(tp,aux.Stringid(65060016,0)) then
				local g1=Duel.SelectMatchingCard(tp,c65060016.spfil,tp,LOCATION_HAND,0,1,1,nil,e,tp)
				if g1:GetCount()>0 then
					Duel.SpecialSummon(g1,0,tp,tp,false,false,POS_FACEUP)
				end
			end
		end
		if tc:IsType(TYPE_SPELL) and Duel.IsExistingMatchingCard(c65060016.thfil,tp,LOCATION_DECK,0,1,nil) then
			if Duel.SelectYesNo(tp,aux.Stringid(65060016,1)) then
				local g2=Duel.SelectMatchingCard(tp,c65060016.thfil,tp,LOCATION_DECK,0,1,1,nil)
				if g2:GetCount()>0 then
					Duel.SendtoHand(g2,tp,REASON_EFFECT)
					Duel.ConfirmCards(1-tp,g2)
				end
			end
		end
		if tc:IsType(TYPE_TRAP) and Duel.IsExistingMatchingCard(nil,tp,LOCATION_GRAVE,0,1,nil) then
			if Duel.SelectYesNo(tp,aux.Stringid(65060016,2)) then
				local g3=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_GRAVE,0,1,1,nil)
				if g3:GetCount()>0 then
					Duel.SendtoHand(g3,tp,REASON_EFFECT)
					Duel.ConfirmCards(1-tp,g3)
				end
			end
		end
	end
end
function c65060016.spfil(c,e,tp)
	return c:IsSetCard(0x6da4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsType(TYPE_MONSTER)
end
function c65060016.thfil(c)
	return c:IsSetCard(0x6da4) and c:IsAbleToHand()
end
function c65060016.effcon(e)
	return e:GetHandler():GetAttack()<=100
end
function c65060016.distg(e,c)
	return c:IsFacedown()
end
function c65060016.sumcon(e)
	return e:GetHandler():GetAttack()<=100
end
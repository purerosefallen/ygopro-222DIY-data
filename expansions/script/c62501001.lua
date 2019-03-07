--病態的正義 綾弥一条
function c62501001.initial_effect(c)
local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(62501001,1))
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetTarget(c62501001.eqtg)
	e1:SetOperation(c62501001.eqop)
	c:RegisterEffect(e1)
local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2) 
local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(62501001,0))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,62501001)
	e3:SetTarget(c62501001.target)
	e3:SetOperation(c62501001.activate)
	c:RegisterEffect(e3)
end
function c62501001.eqfil(c)
	return c:IsCode(62501006) 
end
function c62501001.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c62501001.eqfil,tp,LOCATION_GRAVE,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,nil,1,0,0)
end
function c62501001.eqop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsExistingMatchingCard(c62501001.eqfil,tp,LOCATION_GRAVE,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
		local g=Duel.SelectMatchingCard(tp,c62501001.eqfil,tp,LOCATION_GRAVE,0,1,1,nil)
		local tc=g:GetFirst()
		local c=e:GetHandler()
		Duel.Equip(tp,tc,c)
		if Duel.Equip(tp,tc,c)==0 then return end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_EQUIP)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(1000)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
	   e2:SetCode(EFFECT_EQUIP_LIMIT)
	   e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	   e2:SetValue(c62501001.eqlimit)
	  e2:SetReset(RESET_EVENT+RESETS_STANDARD)
	   tc:RegisterEffect(e2)
		--atkup 
	end
end
function c62501001.eqlimit(e,c)
	return e:GetOwner()==c
end
function c62501001.filter(c,e,tp,ft)
	return c:IsSetCard(0x626) and c:IsAbleToHand()
end
function c62501001.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c62501001.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c62501001.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c62501001.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
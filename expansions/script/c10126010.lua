--神匠器 神猿
function c10126010.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c10126010.eqtg)
	e1:SetOperation(c10126010.eqop)
	c:RegisterEffect(e1)	
	--Equip limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EQUIP_LIMIT)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetValue(c10126010.eqlimit)
	c:RegisterEffect(e2)  
	--Atk&def
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_EQUIP)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetValue(c10126010.value)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e4)
	--tohand
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(10126010,0))
	e5:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_BATTLE_DESTROYING)
	e5:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCountLimit(1,10126010)
	e5:SetCondition(c10126010.thcon)
	e5:SetTarget(c10126010.thtg)
	e5:SetOperation(c10126010.thop)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCondition(c10126010.thcon2)
	--e6:SetProperty(EFFECT_FLAG_DELAY)
	e6:SetCode(EVENT_CHAIN_SOLVING)
	c:RegisterEffect(e6)
	--equip
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(10126010,1))
	e7:SetCategory(CATEGORY_EQUIP+CATEGORY_TOHAND)
	e7:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e7:SetCode(EVENT_TO_GRAVE)
	e7:SetCountLimit(1,10126110)
	e7:SetCondition(c10126010.thcon3)
	e7:SetTarget(c10126010.thtg3)
	e7:SetOperation(c10126010.thop3)
	c:RegisterEffect(e7)
	local e8=e7:Clone()
	e8:SetCondition(c10126010.thcon4)
	e8:SetCode(EVENT_RELEASE)
	c:RegisterEffect(e8)
end
function c10126010.eqlimit(e,c)
	return c:IsSetCard(0x1335)
end
function c10126010.eqfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x1335)
end
function c10126010.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c10126010.eqfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c10126010.eqfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c10126010.eqfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c10126010.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
	   Duel.Equip(tp,c,tc)
	end
end
function c10126010.thcon4(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return not c:IsLocation(LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE)
end
function c10126010.thcon3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_ONFIELD) or c:IsReason(REASON_RELEASE)
end
function c10126010.efilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x1335) and Duel.IsExistingMatchingCard(c10126010.efilter2,tp,LOCATION_HAND,0,1,nil,c)
end
function c10126010.efilter2(c,ec)
	return c:IsType(TYPE_EQUIP) and c:CheckEquipTarget(ec)
end
function c10126010.thtg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,e:GetHandler():GetLocation())
end
function c10126010.thop3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SendtoHand(c,nil,REASON_EFFECT)~=0 and c:IsLocation(LOCATION_HAND) then
	   local g=Duel.GetMatchingGroup(c10126010.efilter,tp,LOCATION_MZONE,0,nil,tp)
	   if g:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.SelectYesNo(tp,aux.Stringid(10126010,2)) then
		  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELF)
		  local tc=g:Select(tp,1,1,nil):GetFirst()
		  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		  local tc2=Duel.SelectMatchingCard(tp,c10126010.efilter2,tp,LOCATION_HAND,0,1,1,nil,tc):GetFirst()
		  Duel.Equip(tp,tc2,tc)
	   end
	end
end
function c10126010.value(e,c)
	return Duel.GetMatchingGroupCount(c10126010.cfilter,c:GetControler(),LOCATION_SZONE,LOCATION_SZONE,nil,c:GetControler())*200
end
function c10126010.cfilter(c,tp)
	local ec=c:GetEquipTarget()
	return ec and ec:IsControler(tp) 
end
function c10126010.thcon2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetEquipTarget()==re:GetHandler()
end
function c10126010.thcon(e,tp,eg,ep,ev,re,r,rp)
	local ec=eg:GetFirst()
	local bc=ec:GetBattleTarget()
	return e:GetHandler():GetEquipTarget()==ec and ec:IsControler(tp)
		and bc:IsReason(REASON_BATTLE) and bc:GetPreviousControler()~=tp
end
function c10126010.thfilter(c)
	return c:IsSetCard(0x1335) and c:IsAbleToHand()
end
function c10126010.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.NecroValleyFilter(c10126010.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c10126010.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c10126010.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
	   Duel.SendtoHand(g,nil,REASON_EFFECT)
	   Duel.ConfirmCards(1-tp,g)
	end
end
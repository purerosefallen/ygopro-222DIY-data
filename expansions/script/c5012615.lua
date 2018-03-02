--这个世界谁最美丽
function c5012615.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(c5012615.activate)
	c:RegisterEffect(e1)
	--lv
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(5012615,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_FZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(2)
	e2:SetTarget(c5012615.target)
	e2:SetOperation(c5012615.operation)
	c:RegisterEffect(e2)
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(5012615,2))
	e3:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_FZONE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1,5012615)
	e3:SetCost(c5012615.descost)
	e3:SetTarget(c5012615.destg)
	e3:SetOperation(c5012615.desop)
	c:RegisterEffect(e3)
end
function c5012615.thfilter(c)
	return (c:IsSetCard(0x250) or c:IsSetCard(0x23c) ) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c5012615.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c5012615.thfilter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(5012615,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetValue(c5012615.aclimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c5012615.aclimit(e,re,tp)
	return re:GetHandler():IsType(TYPE_FIELD) and re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function c5012615.filter(c)
	return c:IsFaceup() and (c:IsSetCard(0x250) or c:IsSetCard(0x23c) )
end
function c5012615.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c5012615.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c5012615.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c5012615.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end
function c5012615.operation(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
	if tc:GetLevel()>0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		else
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_RANK)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
	end
end
end
function c5012615.refilter(c,tp)
	return  c:IsControler(tp) and (c:IsSetCard(0x250) or c:IsSetCard(0x23c) ) and c:IsType(TYPE_MONSTER)
end
function c5012615.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c5012615.refilter,1,nil,tp) end
	local g=Duel.SelectReleaseGroup(tp,c5012615.refilter,1,1,nil,tp)
	Duel.Release(g,REASON_COST)
end
function c5012615.lpfilter(c)
	return c:GetCode()==5012619 and c:IsFaceup()
end
function c5012615.kmfilter(c)
	return c:IsCode(5015617) and c:IsFaceup() 
end
function c5012615.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsDestructable() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsDestructable,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)  end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,Card.IsDestructable,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c5012615.desop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,5012619,0x1101b,0x4011,1245,0,3,RACE_ZOMBIE,ATTRIBUTE_DARK)
	and Duel.GetLocationCount(tc:GetPreviousControler(),LOCATION_MZONE)>0  and Duel.SelectYesNo(tp,aux.Stringid(5012615,3)) then 
	 local token1=Duel.CreateToken(tp,5012619)
		if Duel.SpecialSummon(token1,0,tp,tc:GetPreviousControler(),false,false,POS_FACEUP)>0 and Duel.GetMatchingGroupCount(c5012615.lpfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)>=5 
		and  Duel.IsExistingMatchingCard(c5012615.kmfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)  then   
   Duel.RaiseEvent(e:GetHandler(),5012617,e,0,0,0,0)
	end
end
end
--宇宙战争机器 晶核
function c13257214.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(13257214,0))
	e1:SetCategory(CATEGORY_POSITION+CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c13257214.postg)
	e1:SetOperation(c13257214.posop)
	c:RegisterEffect(e1)
	--immune
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c13257214.tgcon)
	e2:SetValue(aux.imval1)
	c:RegisterEffect(e2)
	--deck equip
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(13257214,2))
	e3:SetCategory(CATEGORY_EQUIP)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTarget(c13257214.eqtg)
	e3:SetOperation(c13257214.eqop)
	c:RegisterEffect(e3)
	local e12=Effect.CreateEffect(c)
	e12:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e12:SetCode(EVENT_SUMMON_SUCCESS)
	e12:SetOperation(c13257214.bgmop)
	c:RegisterEffect(e12)
	c:RegisterFlagEffect(13257200,0,0,0,1)
	eflist={"deck_equip",e3}
	c13257214[c]=eflist
	
end
function c13257214.thfilter(c)
	return c:IsSetCard(0x353) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c13257214.postg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c13257214.thfilter,tp,LOCATION_DECK,0,1,nil) end
	e:GetHandler():RegisterFlagEffect(13257214,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END+RESET_OPPO_TURN,0,1)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c13257214.posop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local sg=Duel.SelectMatchingCard(tp,c13257214.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if sg:GetCount()>0 then
		local ct=Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
		local g=Duel.GetMatchingGroup(Card.IsAttackPos,tp,0,LOCATION_MZONE,nil)
		if ct>0 and g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(13257214,1)) then
			Duel.ChangePosition(g,POS_FACEUP_DEFENSE)
		end
	end
end
function c13257214.tgcon(e)
	return e:GetHandler():GetFlagEffect(13257214)==0
end
function c13257214.eqfilter(c,ec)
	return c:IsSetCard(0x354) and c:IsType(TYPE_MONSTER) and c:CheckEquipTarget(ec)
end
function c13257214.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c13257214.eqfilter,tp,LOCATION_EXTRA,0,1,nil,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_EXTRA)
end
function c13257214.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 or c:IsFacedown() or not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectMatchingCard(tp,c13257214.eqfilter,tp,LOCATION_EXTRA,0,1,1,nil,c)
	local tc=g:GetFirst()
	if tc then
		Duel.Equip(tp,tc,c)
	end
end
function c13257214.bgmop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(11,0,aux.Stringid(13257214,4))
end

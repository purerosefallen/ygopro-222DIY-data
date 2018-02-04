--当代的白沢球记者
function c22220007.initial_effect(c)
	--equip
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(22220007,0))
	e0:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e0:SetCategory(CATEGORY_EQUIP)
	e0:SetType(EFFECT_TYPE_QUICK_O)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetRange(LOCATION_MZONE+LOCATION_HAND)
	e0:SetTarget(c22220007.eqtg)
	e0:SetOperation(c22220007.eqop)
	c:RegisterEffect(e0)
	--unequip
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22220007,1))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_SZONE)
	e1:SetTarget(c22220007.sptg)
	e1:SetOperation(c22220007.spop)
	c:RegisterEffect(e1)
	--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22220007,2))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET)
	e2:SetTarget(c22220007.thtg)
	e2:SetOperation(c22220007.thop)
	c:RegisterEffect(e2)
	--gain effect
	local e3=Effect.CreateEffect(c)  
	e3:SetDescription(aux.Stringid(22220007,3))  
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)  
	e3:SetCountLimit(1)
	e3:SetTarget(c22220007.indtg)  
	e3:SetOperation(c22220007.indop)  
	local e4=Effect.CreateEffect(c)  
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)  
	e4:SetRange(LOCATION_SZONE)  
	e4:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)  
	e4:SetTarget(c22220007.eftg)  
	e4:SetLabelObject(e3)  
	c:RegisterEffect(e4)  
	--eqlimit
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_EQUIP_LIMIT)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e5:SetValue(c22220007.eqlimit)
	c:RegisterEffect(e5)
end
function c22220007.eqlimit(e,c)
	return c:IsSetCard(0x50f) or e:GetHandler():GetEquipTarget()==c
end
function c22220007.eqfilter(c)
	local ct1,ct2=c:GetUnionCount()
	return c:IsFaceup() and c:IsSetCard(0x50f) and ct2==0
end
function c22220007.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c22220007.eqfilter(chkc) end
	if chk==0 then return c:GetFlagEffect(22220007)==0 and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(c22220007.eqfilter,tp,LOCATION_MZONE,0,1,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectTarget(tp,c22220007.eqfilter,tp,LOCATION_MZONE,0,1,1,c)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
	c:RegisterFlagEffect(22220007,RESET_EVENT+0x7e0000+RESET_PHASE+PHASE_END,0,1)
end
function c22220007.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not c:IsRelateToEffect(e) or (c:IsLocation(LOCATION_MZONE) and c:IsFacedown()) then return end
	if not tc:IsRelateToEffect(e) or not c22220007.eqfilter(tc) then
		Duel.SendtoGrave(c,REASON_EFFECT)
		return
	end
	if not Duel.Equip(tp,c,tc,true) then return end
	aux.SetUnionState(c)
end
function c22220007.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetFlagEffect(22220007)==0 and Duel.GetMZoneCount(tp)>0 and c:IsCanBeSpecialSummoned(e,0,tp,true,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
	c:RegisterFlagEffect(22220007,RESET_EVENT+0x7e0000+RESET_PHASE+PHASE_END,0,1)
end
function c22220007.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP)
end
function c22220007.eftg(e,c)  
	return e:GetHandler():GetEquipTarget()==c  
end
function c22220007.indtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFacedown,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
	local ac=Duel.AnnounceCard(tp)
	Duel.SetTargetParam(ac)
	Duel.SetOperationInfo(0,CATEGORY_ANNOUNCE,nil,0,tp,ANNOUNCE_CARD)
end  
function c22220007.indop(e,tp,eg,ep,ev,re,r,rp)
	local ac=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	local g=Duel.GetMatchingGroup(Card.IsFacedown,tp,0,LOCATION_ONFIELD,nil)
	if g:GetCount()>0 then
		Duel.ConfirmCards(tp,g)
		local sg=g:Filter(Card.IsCode,nil,ac)
		if sg:GetCount()>0 then
			tg=sg:Select(tp,1,1,nil)
			Duel.SendtoHand(tg,tp,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tg)
		end
	end
end
function c22220007.thfilter(c)
	return c:IsFaceup() and c:IsAbleToHand() and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable() and not c:IsType(TYPE_FIELD)
end
function c22220007.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chck==0 then return c22220007.thfilter(chkc) and chkc:IsLocation(LOCATION_REMOVED) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.IsExistingTarget(c22220007.thfilter,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c22220007.thfilter,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,1,nil)
end
function c22220007.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<1 then return end
	if not tc:IsRelateToEffect(e) then return end
	if not tc:IsSSetable() then return end
	Duel.SSet(tp,tc,tp)
end
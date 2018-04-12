--里超时空战斗机-Arwing
function c13257338.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(13257338,4))
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c13257338.spcon)
	e1:SetTarget(c13257338.sptg)
	e1:SetOperation(c13257338.spop)
	c:RegisterEffect(e1)
	--Power Capsule
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(13257338,0))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1)
	e2:SetCondition(c13257338.pccon)
	e2:SetTarget(c13257338.pctg)
	e2:SetOperation(c13257338.pcop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(13257338,5))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCountLimit(1)
	e3:SetTarget(c13257338.adtg)
	e3:SetOperation(c13257338.adop)
	c:RegisterEffect(e3)
	eflist={"power_capsule",e2}
	c13257338[c]=eflist
	
end
function c13257338.eqfilter(c,ec)
	return c:IsSetCard(0x352) and c:IsType(TYPE_MONSTER) and c:CheckEquipTarget(ec)
end
function c13257338.spfilter(c)
	return c:IsSetCard(0x351) and c:IsFaceup()
end
function c13257338.cfilter(c,tp)
	return c:GetSummonPlayer()~=tp
end
function c13257338.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c13257338.cfilter,1,nil,tp) and Duel.IsExistingMatchingCard(c13257338.spfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c13257338.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.IsExistingMatchingCard(c13257338.eqfilter,tp,LOCATION_EXTRA,0,1,nil,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c13257338.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsRelateToEffect(e) then
		if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
			Duel.Hint(11,0,aux.Stringid(13257338,7))
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
			local g=Duel.SelectMatchingCard(tp,c13257338.eqfilter,tp,LOCATION_EXTRA,0,1,1,nil,c)
			local tc=g:GetFirst()
			if tc then
				Duel.Equip(tp,tc,c)
			end
		end
	end
end
function c13257338.cfilter1(c,tp)
	return c:GetPreviousControler()==tp and c:IsReason(REASON_BATTLE+REASON_EFFECT)
end
function c13257338.pccon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c13257338.cfilter1,1,nil,1-tp)
end
function c13257338.pctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetEquipCount()>0 or  Duel.IsExistingMatchingCard(c13257338.eqfilter,tp,LOCATION_EXTRA,0,1,nil,e:GetHandler()) end
	e:SetCategory(CATEGORY_EQUIP)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_EXTRA)
end
function c13257338.pcop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local eq=c:GetEquipGroup()
	local g=eq:Filter(Card.IsAbleToDeck,nil)
	local op=0
	if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
	if Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and g:GetCount()>0 and (not Duel.IsExistingMatchingCard(c13257338.eqfilter,tp,LOCATION_EXTRA,0,1,nil,c) or Duel.SelectYesNo(tp,aux.Stringid(13257338,3))) then op=1
	elseif Duel.GetLocationCount(tp,LOCATION_SZONE)==0 and g:GetCount()>0 then op=1
	end
	if op==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)
	end
	Duel.BreakEffect()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	g=Duel.SelectMatchingCard(tp,c13257338.eqfilter,tp,LOCATION_EXTRA,0,1,1,nil,c)
	local tc=g:GetFirst()
	if tc then
		Duel.Equip(tp,tc,c)
	end
end
function c13257338.adtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local t1=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
	local op=0
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(13257338,1))
	if t1 then
		op=Duel.SelectOption(tp,aux.Stringid(13257338,8),aux.Stringid(13257338,9))
	else
		op=Duel.SelectOption(tp,aux.Stringid(13257338,9))+1
	end
	e:SetLabel(op)
	if op==0 then
	elseif op==1 then
		e:SetCategory(CATEGORY_ATKCHANGE)
	end
end
function c13257338.adop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if e:GetLabel()==0 then
		if not c:IsRelateToEffect(e) or c:IsControler(1-tp) then return end
		if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
			local s=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,0)
			local nseq=0
			if s==1 then nseq=0
			elseif s==2 then nseq=1
			elseif s==4 then nseq=2
			elseif s==8 then nseq=3
			else nseq=4 end
			Duel.MoveSequence(c,nseq)
		end
	else
		if c:IsRelateToEffect(e) and c:IsFaceup() then
			local e7=Effect.CreateEffect(c)
			e7:SetType(EFFECT_TYPE_SINGLE)
			e7:SetCode(EFFECT_UPDATE_ATTACK)
			e7:SetValue(-500)
			e7:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END)
			c:RegisterEffect(e7)
			local e8=Effect.CreateEffect(c)
			e8:SetType(EFFECT_TYPE_SINGLE)
			e8:SetCode(EFFECT_IMMUNE_EFFECT)
			e8:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
			e8:SetRange(LOCATION_MZONE)
			e8:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END)
			e8:SetValue(c13257338.efilter)
			c:RegisterEffect(e8)
			local e9=Effect.CreateEffect(e:GetHandler())
			e9:SetDescription(aux.Stringid(13257338,9))
			e9:SetProperty(EFFECT_FLAG_CLIENT_HINT)
			e9:SetType(EFFECT_TYPE_SINGLE)
			e9:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			c:RegisterEffect(e9)
		end
	end
end
function c13257338.efilter(e,te)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer()
		and not te:IsHasProperty(EFFECT_FLAG_CARD_TARGET)
end

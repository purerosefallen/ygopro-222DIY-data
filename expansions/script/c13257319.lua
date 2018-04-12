--超时空战斗机-Big Core Custom
function c13257319.initial_effect(c)
	--special summon
	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e11:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e11:SetCode(EVENT_LEAVE_FIELD)
	e11:SetRange(LOCATION_HAND)
	e11:SetOperation(c13257319.regop)
	c:RegisterEffect(e11)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(13257319,5))
	e3:SetCategory(CATEGORY_EQUIP)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTarget(c13257319.eqtg)
	e3:SetOperation(c13257319.eqop)
	c:RegisterEffect(e3)
	--Power Capsule
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(13257319,0))
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_DESTROYED)
	e4:SetRange(LOCATION_MZONE)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e4:SetCondition(c13257319.pccon)
	e4:SetTarget(c13257319.pctg)
	e4:SetOperation(c13257319.pcop)
	c:RegisterEffect(e4)
	local e13=Effect.CreateEffect(c)
	e13:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e13:SetCode(EVENT_SUMMON_SUCCESS)
	e13:SetOperation(c13257319.bgmop)
	c:RegisterEffect(e13)
	local e14=e13:Clone()
	e14:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e14)
	eflist={"power_capsule",e4,"deck_equip",e3}
	c13257319[c]=eflist
	c:RegisterFlagEffect(13257200,0,0,0,1)
	
end
function c13257319.cfilter(c,tp)
	return c:IsPreviousLocation(LOCATION_MZONE) and c:GetPreviousControler()==tp and (c:IsSetCard(0x351) or c:IsSetCard(0x353)) and c:IsPreviousPosition(POS_FACEUP) and c:IsReason(REASON_EFFECT) and c:GetReasonPlayer()==1-tp
end
function c13257319.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if eg:IsExists(c13257319.cfilter,1,nil,tp) then
		--spsummon
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(13257319,6))
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_SPSUMMON_PROC)
		e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
		e1:SetRange(LOCATION_HAND)
		e1:SetCondition(c13257319.spcon)
		e1:SetOperation(c13257319.spop)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	end
end
function c13257319.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end
function c13257319.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(11,0,aux.Stringid(13257319,7))
end
function c13257319.eqfilter1(c,ec)
	return c:IsSetCard(0x354) and c:IsType(TYPE_MONSTER) and c:CheckEquipTarget(ec)
end
function c13257319.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c13257319.eqfilter1,tp,LOCATION_EXTRA,0,1,nil,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_EXTRA)
end
function c13257319.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 or c:IsFacedown() or not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectMatchingCard(tp,c13257319.eqfilter1,tp,LOCATION_EXTRA,0,1,1,nil,c)
	local tc=g:GetFirst()
	if tc then
		Duel.Equip(tp,tc,c)
	end
end
function c13257319.pcfilter(c,tp)
	return c:IsReason(REASON_BATTLE+REASON_EFFECT) and c:IsPreviousLocation(LOCATION_MZONE) and c:GetPreviousControler()==tp
end
function c13257319.pccon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c13257319.pcfilter,1,nil,1-tp)
end
function c13257319.eqfilter(c,ec)
	return c:IsSetCard(0x3352) and c:IsType(TYPE_MONSTER) and c:CheckEquipTarget(ec)
end
function c13257319.pctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetEquipCount()>0 or  Duel.IsExistingMatchingCard(c13257319.eqfilter,tp,LOCATION_EXTRA,0,1,nil,e:GetHandler()) end
	e:SetCategory(CATEGORY_EQUIP)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_EXTRA)
end
function c13257319.pcop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local eq=c:GetEquipGroup()
	local g=eq:Filter(Card.IsAbleToDeck,nil)
	local op=0
	if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
	if Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and g:GetCount()>0 and (not Duel.IsExistingMatchingCard(c13257319.eqfilter,tp,LOCATION_EXTRA,0,1,nil,c) or Duel.SelectYesNo(tp,aux.Stringid(13257319,3))) then op=1
	elseif Duel.GetLocationCount(tp,LOCATION_SZONE)==0 and g:GetCount()>0 then op=1
	end
	if op==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)
	end
	Duel.BreakEffect()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	g=Duel.SelectMatchingCard(tp,c13257319.eqfilter,tp,LOCATION_EXTRA,0,1,1,nil,c)
	local tc=g:GetFirst()
	if tc then
		Duel.Equip(tp,tc,c)
	end
end
function c13257319.bgmop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(11,0,aux.Stringid(13257319,7))
end

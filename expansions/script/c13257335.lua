--超时空战斗机-Blue Thunder M-45
function c13257335.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(13257335,3))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,13257335)
	e1:SetTarget(c13257335.sptg)
	e1:SetOperation(c13257335.spop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--Power Capsule
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(13257335,0))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCondition(c13257335.pccon)
	e3:SetTarget(c13257335.pctg)
	e3:SetOperation(c13257335.pcop)
	c:RegisterEffect(e3)
	--Option Control
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(13257335,6))
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e4:SetCountLimit(1)
	e4:SetCondition(c13257335.occon)
	e4:SetTarget(c13257335.octg)
	e4:SetOperation(c13257335.ocop)
	c:RegisterEffect(e4)
	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e11:SetCode(EVENT_SUMMON_SUCCESS)
	e11:SetOperation(c13257335.bgmop)
	c:RegisterEffect(e11)
	eflist={"power_capsule",e3}
	c13257335[c]=eflist
	
end
function c13257335.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
end
function c13257335.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local atk=c:GetAttack()
	local def=c:GetDefense()
	local lv=c:GetLevel()
	local race=c:GetRace()
	local att=c:GetAttribute()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 or not c:IsRelateToEffect(e)
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,93130022,0,0x4011,atk,def,lv,race,att) then return end
	local token=Duel.CreateToken(tp,93130022)
		c:CreateRelation(token,RESET_EVENT+0x1fe0000)
		Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetValue(c13257335.tokenatk)
		e1:SetReset(RESET_EVENT+0xfe0000)
		token:RegisterEffect(e1,true)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_SET_DEFENSE_FINAL)
		e2:SetValue(c13257335.tokendef)
		token:RegisterEffect(e2,true)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_CHANGE_LEVEL)
		e3:SetValue(c13257335.tokenlv)
		e3:SetReset(RESET_EVENT+0xfe0000)
		token:RegisterEffect(e3,true)
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_SINGLE)
		e4:SetCode(EFFECT_CHANGE_RACE)
		e4:SetValue(c13257335.tokenrace)
		e4:SetReset(RESET_EVENT+0xfe0000)
		token:RegisterEffect(e4,true)
		local e5=Effect.CreateEffect(c)
		e5:SetType(EFFECT_TYPE_SINGLE)
		e5:SetCode(EFFECT_CHANGE_ATTRIBUTE)
		e5:SetValue(c13257335.tokenatt)
		e5:SetReset(RESET_EVENT+0xfe0000)
		token:RegisterEffect(e5,true)
		local e6=Effect.CreateEffect(c)
		e6:SetType(EFFECT_TYPE_SINGLE)
		e6:SetCode(EFFECT_SELF_DESTROY)
		e6:SetCondition(c13257335.tokendes)
		e6:SetReset(RESET_EVENT+0xfe0000)
		token:RegisterEffect(e6,true)
		Duel.SpecialSummonComplete()
		c:SetCardTarget(token)
end
function c13257335.tokenatk(e,c)
	return e:GetOwner():GetAttack()
end
function c13257335.tokendef(e,c)
	return e:GetOwner():GetDefense()
end
function c13257335.tokenlv(e,c)
	return e:GetOwner():GetLevel()
end
function c13257335.tokenrace(e,c)
	return e:GetOwner():GetRace()
end
function c13257335.tokenatt(e,c)
	return e:GetOwner():GetAttribute()
end
function c13257335.tokendes(e)
	return not e:GetOwner():IsRelateToCard(e:GetHandler())
end
function c13257335.eqfilter(c,ec)
	return c:IsSetCard(0x3352) and c:IsType(TYPE_MONSTER) and c:CheckEquipTarget(ec)
end
function c13257335.pcfilter(c,tp)
	return c:IsReason(REASON_BATTLE+REASON_EFFECT) and c:IsPreviousLocation(LOCATION_MZONE) and c:GetPreviousControler()==tp
end
function c13257335.pccon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c13257335.pcfilter,1,nil,1-tp)
end
function c13257335.pctg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local t1=c:GetEquipCount()>0 or Duel.IsExistingMatchingCard(c13257335.eqfilter,tp,LOCATION_EXTRA,0,1,nil,c)
	local t2=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,93130022,0,0x4011,c:GetAttack(),c:GetDefense(),c:GetLevel(),c:GetRace(),c:GetAttribute())
	if chk==0 then return t1 or t2 end
	local op=0
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(13257335,1))
	if t1 and t2 then
		op=Duel.SelectOption(tp,aux.Stringid(13257335,2),aux.Stringid(13257335,3))
	elseif t1 then
		op=Duel.SelectOption(tp,aux.Stringid(13257335,2))
	elseif t2 then
		op=Duel.SelectOption(tp,aux.Stringid(13257335,3))+1
	end
	e:SetLabel(op)
	if op==0 then
		e:SetCategory(CATEGORY_EQUIP)
		Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_EXTRA)
	elseif op==1 then
		e:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
		Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	end
end
function c13257335.pcop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if e:GetLabel()==0 then
		local eq=c:GetEquipGroup()
		local g=eq:Filter(Card.IsAbleToDeck,nil)
		local op=0
		if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
		if Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and g:GetCount()>0 and (not Duel.IsExistingMatchingCard(c13257335.eqfilter,tp,LOCATION_EXTRA,0,1,nil,c) or Duel.SelectYesNo(tp,aux.Stringid(13257335,4))) then op=1
		elseif Duel.GetLocationCount(tp,LOCATION_SZONE)==0 and g:GetCount()>0 then op=1
		end
		if op==1 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
			local sg=g:Select(tp,1,1,nil)
			Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)
		end
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		g=Duel.SelectMatchingCard(tp,c13257335.eqfilter,tp,LOCATION_EXTRA,0,1,1,nil,c)
		local tc=g:GetFirst()
		if tc then
			Duel.Equip(tp,tc,c)
		end
	elseif e:GetLabel()==1 then
		local atk=c:GetAttack()
		local def=c:GetDefense()
		local lv=c:GetLevel()
		local race=c:GetRace()
		local att=c:GetAttribute()
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 or not c:IsRelateToEffect(e) or c:IsFacedown()
			or not Duel.IsPlayerCanSpecialSummonMonster(tp,93130022,0,0x4011,atk,def,lv,race,att) then return end
		local token=Duel.CreateToken(tp,93130022)
		c:CreateRelation(token,RESET_EVENT+0x1fe0000)
		Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetValue(c13257335.tokenatk)
		e1:SetReset(RESET_EVENT+0xfe0000)
		token:RegisterEffect(e1,true)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_SET_DEFENSE_FINAL)
		e2:SetValue(c13257335.tokendef)
		token:RegisterEffect(e2,true)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_CHANGE_LEVEL)
		e3:SetValue(c13257335.tokenlv)
		e3:SetReset(RESET_EVENT+0xfe0000)
		token:RegisterEffect(e3,true)
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_SINGLE)
		e4:SetCode(EFFECT_CHANGE_RACE)
		e4:SetValue(c13257335.tokenrace)
		e4:SetReset(RESET_EVENT+0xfe0000)
		token:RegisterEffect(e4,true)
		local e5=Effect.CreateEffect(c)
		e5:SetType(EFFECT_TYPE_SINGLE)
		e5:SetCode(EFFECT_CHANGE_ATTRIBUTE)
		e5:SetValue(c13257335.tokenatt)
		e5:SetReset(RESET_EVENT+0xfe0000)
		token:RegisterEffect(e5,true)
		local e6=Effect.CreateEffect(c)
		e6:SetType(EFFECT_TYPE_SINGLE)
		e6:SetCode(EFFECT_SELF_DESTROY)
		e6:SetCondition(c13257335.tokendes)
		e6:SetReset(RESET_EVENT+0xfe0000)
		token:RegisterEffect(e6,true)
		Duel.SpecialSummonComplete()
		c:SetCardTarget(token)
	end
end
function c13257335.ocfilter(c)
	return c:IsFaceup() and c:IsCode(93130022)
end
function c13257335.occon(e,tp,eg,ep,ev,re,r,rp)
	local og=e:GetHandler():GetCardTarget()
	return og and og:IsExists(c13257335.ocfilter,1,nil)
end
function c13257335.octg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local op=0
	if Duel.GetCurrentPhase()==PHASE_DAMAGE then
		op=Duel.SelectOption(tp,aux.Stringid(13257335,8))
	else
		op=Duel.SelectOption(tp,aux.Stringid(13257335,8),aux.Stringid(13257335,9))
	end
	e:SetLabel(op)
end
function c13257335.ocop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if e:GetLabel()==0 then
		local e7=Effect.CreateEffect(c)
		e7:SetType(EFFECT_TYPE_SINGLE)
		e7:SetCode(EFFECT_UPDATE_ATTACK)
		e7:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e7:SetRange(LOCATION_MZONE)
		e7:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e7:SetValue(c13257335.val)
		c:RegisterEffect(e7)
	else
		local e8=Effect.CreateEffect(c)
		e8:SetType(EFFECT_TYPE_SINGLE)
		e8:SetCode(EFFECT_IMMUNE_EFFECT)
		e8:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e8:SetRange(LOCATION_MZONE)
		e8:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e8:SetCondition(c13257335.efcon)
		e8:SetValue(c13257335.efilter)
		c:RegisterEffect(e8)
	end
end
function c13257335.val(e,c)
	local og=c:GetCardTarget()
	local g=og:Filter(c13257335.ocfilter,nil)
	return g:GetCount()*400
end
function c13257335.efcon(e)
	local og=e:GetHandler():GetCardTarget()
	return og and og:GetCount()>0
end
function c13257335.efilter(e,te)
	return te:GetOwnerPlayer()~=e:GetOwnerPlayer()
end
function c13257335.bgmop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(11,0,aux.Stringid(13257335,7))
end

--夜煌蝶
function c1170005.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c1170005.tg1)
	e1:SetOperation(c1170005.op1)
	c:RegisterEffect(e1)
--
end
--
function c1170005.tfilter1(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsType(TYPE_SPIRIT) and Duel.IsPlayerCanSpecialSummonMonster(tp,c:GetCode(),0,0x4011,0,0,1,RACE_ZOMBIE,ATTRIBUTE_DARK)
end
function c1170005.tg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and c1170005.tfilter1(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c1170005.tfilter1,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELF)
	local sg=Duel.SelectTarget(tp,c1170005.tfilter1,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	local num=Duel.GetLocationCount(tp,LOCATION_MZONE)
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,num,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,num,0,0)
end
--
function c1170005.op1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	local fid=c:GetFieldID()
	local tc=Duel.GetFirstTarget()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,tc:GetCode(),0,0x4011,0,0,1,RACE_ZOMBIE,ATTRIBUTE_DARK) then
		local sg=Group.CreateGroup()
		if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
		for i=1,ft do
			local token=Duel.CreateToken(tp,1170006)
			Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
			token:RegisterFlagEffect(1170005,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1,fid)
			sg:AddCard(token)
			local e1_1=Effect.CreateEffect(c)
			e1_1:SetType(EFFECT_TYPE_SINGLE)
			e1_1:SetCode(EFFECT_CHANGE_CODE)
			e1_1:SetValue(tc:GetCode())
			e1_1:SetReset(RESET_EVENT+0xfe0000)
			token:RegisterEffect(e1_1,true)
		end
		Duel.SpecialSummonComplete()
		sg:KeepAlive()
		local e1_2=Effect.CreateEffect(c)
		e1_2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1_2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1_2:SetCode(EVENT_PHASE+PHASE_END)
		e1_2:SetCountLimit(1)
		e1_2:SetLabel(fid)
		e1_2:SetLabelObject(sg)
		e1_2:SetCondition(c1170005.con1_2)
		e1_2:SetOperation(c1170005.op1_2)
		e1_2:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1_2,tp)
	end
	local e1_3=Effect.CreateEffect(c)
	e1_3:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1_3:SetType(EFFECT_TYPE_FIELD)
	e1_3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1_3:SetTargetRange(1,0)
	e1_3:SetTarget(function(e,c,sump,sumtype,sumpos,targetp,se)
		return not (se:IsHasType(EFFECT_TYPE_ACTIONS) and not se:IsHasType(EFFECT_TYPE_CONTINUOUS)) end)
	e1_3:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1_3,tp)
end
--
function c1170005.cfilter1_2(c,fid)
	return c:GetFlagEffectLabel(1170005)==fid
end
function c1170005.con1_2(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	if not g:IsExists(c1170005.cfilter1_2,1,nil,e:GetLabel()) then
		g:DeleteGroup()
		e:Reset()
		return false
	else return true end
end
function c1170005.op1_2(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	local tg=g:Filter(c1170005.cfilter1_2,nil,e:GetLabel())
	g:DeleteGroup()
	Duel.Destroy(tg,REASON_EFFECT)
end
--
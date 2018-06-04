--绯色希望·朱丽叶
function c1161023.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(1161023,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c1161023.tg1)
	e1:SetOperation(c1161023.op1)
	c:RegisterEffect(e1)
--  
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(1161023,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_EQUIP)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCost(c1161023.cost2)
	e2:SetTarget(c1161023.tg2)
	e2:SetOperation(c1161023.op2)
	c:RegisterEffect(e2)
--
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CHANGE_CODE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_HAND)
	e3:SetCondition(c1161023.con3)
	e3:SetValue(1161024)
	c:RegisterEffect(e3)
--
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_EQUIP)
	e4:SetRange(LOCATION_SZONE)
	e4:SetOperation(c1161023.op4)
	c:RegisterEffect(e4)
--
end
--
function c1161023.CheckGroup(c)
	local g=c:GetLinkedGroup()
	local tp=c:GetControler()
	local seq=c:GetSequence()
	if seq<5 then
		if c:IsLinkMarker(LINK_MARKER_BOTTOM) then
			local tc=Duel.GetFieldCard(tp,LOCATION_SZONE,seq)
			if tc and tc:IsDestructable() then g:AddCard(tc) end
		end
		if c:IsLinkMarker(LINK_MARKER_BOTTOM_LEFT) then
			if seq>0 then
				local tc=Duel.GetFieldCard(tp,LOCATION_SZONE,seq-1)
				if tc and tc:IsDestructable() then g:AddCard(tc) end
			end
		end
		if c:IsLinkMarker(LINK_MARKER_BOTTOM_RIGHT) then
			if seq<4 then
				local tc=Duel.GetFieldCard(tp,LOCATION_SZONE,seq+1)
				if tc and tc:IsDestructable() then g:AddCard(tc) end
			end
		end
	end
	return g
end
--
function c1161023.tfilter1(c)
	return c:IsType(TYPE_LINK) and c:IsType(TYPE_MONSTER) and c1161023.CheckGroup(c):GetCount()>0 and c:IsDestructable()
end
function c1161023.tg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c1161023.tfilter1,tp, LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,2,0,LOCATION_ONFIELD)
end
--
function c1161023.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,c1161023.tfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		local g=c1161023.CheckGroup(tc)
		if g:GetCount()>0 then 
			local sg=g:FilterSelect(tp,aux.TRUE,1,1,nil)
			if sg:GetCount()>0 then
				sg:AddCard(tc)
				Duel.Destroy(sg,REASON_EFFECT)
			end
		else
			Duel.Destroy(tc,REASON_EFFECT)
		end
	end
end
--
function c1161023.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return not c:IsPublic() end
	local e2_1=Effect.CreateEffect(c)
	e2_1:SetType(EFFECT_TYPE_SINGLE)
	e2_1:SetCode(EFFECT_PUBLIC)
	e2_1:SetReset(RESET_EVENT+0x1fe0000)
	c:RegisterEffect(e2_1)
end
--
function c1161023.tfilter2_1(c,e,tp)
	return c:IsPreviousLocation(LOCATION_MZONE) and c:GetPreviousLevelOnField()==1 and c:GetPreviousControler()==tp and c:IsCanBeEffectTarget(e) and c:IsType(TYPE_MONSTER)
end
function c1161023.tfilter2_2(c,e,tp,eg)
	return c:IsPreviousLocation(LOCATION_MZONE) and c:GetPreviousLevelOnField()==1 and c:GetPreviousControler()==tp and eg:IsContains(c) and c:IsType(TYPE_MONSTER)
end
function c1161023.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c1161023.tfilter2_1,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c1161023.tfilter2_2,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,eg)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,0,0,LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
--
function c1161023.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		local tc=Duel.GetFirstTarget()
		if tc:IsRelateToEffect(e) then
			local fid=c:GetFieldID()
			c:RegisterFlagEffect(1161023,RESET_EVENT+0x1fe0000,0,0,fid)
			tc:RegisterFlagEffect(1161023,RESET_EVENT+0x1fe0000,0,0,fid)
			local e2_1=Effect.CreateEffect(c)
			e2_1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e2_1:SetCode(EVENT_PHASE+PHASE_END)
			e2_1:SetCountLimit(1)
			e2_1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
			e2_1:SetRange(LOCATION_GRAVE)
			e2_1:SetLabel(fid)
			e2_1:SetLabelObject(c)
			e2_1:SetCondition(c1161023.con2_1)
			e2_1:SetOperation(c1161023.op2_1)
			tc:RegisterEffect(e2_1)
		end
	end
end
function c1161023.con2_1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==1-tp
end
function c1161023.op2_1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetLabelObject()
	local fid=e:GetLabel()
	local tc=e:GetHandler()
	if c:GetFlagEffectLabel(1161023)==fid and tc:GetFlagEffectLabel(1161023)==fid and tc:IsLocation(LOCATION_GRAVE) and c:IsLocation(LOCATION_HAND) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and tc:IsCanBeSpecialSummoned(e,0,tp,false,false) and not Duel.IsPlayerAffectedByEffect(tp,EFFECT_NECRO_VALLEY_IM) then
		if Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)~=0 and tc:IsFaceup() and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
			Duel.Equip(tp,c,tc,true)
			local e2_1_1=Effect.CreateEffect(c)
			e2_1_1:SetType(EFFECT_TYPE_SINGLE)
			e2_1_1:SetCode(EFFECT_CHANGE_TYPE)
			e2_1_1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e2_1_1:SetValue(TYPE_EQUIP+TYPE_SPELL)
			e2_1_1:SetReset(RESET_EVENT+0x1fe0000)
			c:RegisterEffect(e2_1_1)
			local e2_1_2=Effect.CreateEffect(c)
			e2_1_2:SetType(EFFECT_TYPE_SINGLE)
			e2_1_2:SetCode(EFFECT_EQUIP_LIMIT)
			e2_1_2:SetReset(RESET_EVENT+0x1fe0000)
			e2_1_2:SetLabelObject(tc)
			e2_1_2:SetValue(c1161023.limit2_1_2)
			c:RegisterEffect(e2_1_2)
			local e2_1_3=Effect.CreateEffect(c)
			e2_1_3:SetType(EFFECT_TYPE_SINGLE)
			e2_1_3:SetCode(EFFECT_UPDATE_ATTACK)
			e2_1_3:SetReset(RESET_EVENT+0x1fe0000)
			e2_1_3:SetValue(800)
			tc:RegisterEffect(e2_1_3)
		else
			Duel.SendtoGrave(c,REASON_EFFECT)
		end
	end
end
function c1161023.limit2_1_2(e,c)
	return c==e:GetLabelObject()
end
--
function c1161023.con3(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsType(TYPE_EQUIP)
end
--
function c1161023.op4(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if eg:GetFirst()~=e:GetHandler() then return end
	local tc=c:GetEquipTarget()
	if tc then
		local e4_1=Effect.CreateEffect(c)
		e4_1:SetType(EFFECT_TYPE_SINGLE)
		e4_1:SetCode(EFFECT_IMMUNE_EFFECT)
		e4_1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e4_1:SetRange(LOCATION_MZONE)
		e4_1:SetLabelObject(e:GetHandler())
		e4_1:SetCondition(c1161023.con4_1)
		e4_1:SetValue(c1161023.efilter4_1)
		tc:RegisterEffect(e4_1)
		if e4_1:GetHandler()==nil then return end
		local e4_2=Effect.CreateEffect(c)
		e4_2:SetType(EFFECT_TYPE_SINGLE)
		e4_2:SetCode(EFFECT_UPDATE_ATTACK)
		e4_2:SetRange(LOCATION_MZONE)
		e4_2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e4_2:SetLabelObject(e:GetHandler())
		e4_2:SetCondition(c1161023.con4_2)
		e4_2:SetValue(c1161023.val4_2)
		tc:RegisterEffect(e4_2)
		if e4_2:GetHandler()==nil then return end
	end
end
--
function c1161023.con4_1(e)
	local g=e:GetHandler():GetEquipGroup()
	if g:IsContains(e:GetLabelObject()) then
		return not e:GetLabelObject():IsDisabled()
	else 
		return false
	end
end
function c1161023.efilter4_1(e,te)
	return te:IsActiveType(TYPE_MONSTER) and te:GetOwner()~=e:GetOwner()
end
--
function c1161023.con4_2(e)
	local c=e:GetHandler()
	local g=c:GetEquipGroup()
	if g:IsContains(e:GetLabelObject()) then
		return Duel.GetCurrentPhase()==PHASE_DAMAGE_CAL and c:IsRelateToBattle() and c:GetBattleTarget() and not e:GetLabelObject():IsDisabled()
	else
		return false
	end
end
function c1161023.val4_2(e)
	return math.max(e:GetHandler():GetBattleTarget():GetAttack(),0)
end
--


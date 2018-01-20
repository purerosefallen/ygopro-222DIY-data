--甜蜜夏日·小红帽
function c1160023.initial_effect(c)
--
	c:SetSPSummonOnce(1160023)
--  
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(1160023,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DECKDES+CATEGORY_RECOVER)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c1160023.tg2)
	e2:SetOperation(c1160023.op2)
	c:RegisterEffect(e2)
--
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(1160023,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_RECOVER+CATEGORY_TOHAND)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_DELAY)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_REMOVE)
	e3:SetTarget(c1160023.tg3)
	e3:SetOperation(c1160023.op3)
	c:RegisterEffect(e3)
--
	Duel.AddCustomActivityCounter(1160023,ACTIVITY_SPSUMMON,c1160023.counterfilter) 
--
end
--
function c1160023.counterfilter(c)
	return c:GetLevel()==1 or c:IsLocation(LOCATION_EXTRA) 
end
--
function c1160023.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(1160023,tp,ACTIVITY_SPSUMMON)==0 and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>2 end
	local e2_1=Effect.CreateEffect(e:GetHandler())
	e2_1:SetType(EFFECT_TYPE_FIELD)
	e2_1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2_1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2_1:SetReset(RESET_PHASE+PHASE_END)
	e2_1:SetTargetRange(1,0)
	e2_1:SetTarget(c1160023.tg2_1)
	Duel.RegisterEffect(e2_1,tp)
end
function c1160023.tg2_1(e,c)
	return not (c:GetLevel()==1 or c:IsLocation(LOCATION_EXTRA))
end
--
function c1160023.ofilter2_1(c,e,tp)
	return c:GetLevel()==1 and c:GetAttack()>399 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsAttribute(ATTRIBUTE_WATER)
end
function c1160023.ofilter2_2(c)
	return c:IsAbleToGrave() and c:GetType()==TYPE_SPELL 
end
function c1160023.op2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<3 then return end
	local c=e:GetHandler()
	Duel.ConfirmDecktop(tp,3)
	local g=Duel.GetDecktopGroup(tp,3)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and g:FilterCount(c1160023.ofilter2_1,nil,e,tp) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:FilterSelect(tp,c1160023.ofilter2_1,1,1,nil,e,tp)
		if sg:GetCount()>0 then
			local tc=sg:GetFirst()
			local seq=c:GetSequence()
			if seq>4 then return end
			if (seq>0 and Duel.CheckLocation(tp,LOCATION_MZONE,seq-1)) or (seq<4 and Duel.CheckLocation(tp,LOCATION_MZONE,seq+1)) then
				local flag=0
				if seq==0 then
					if not Duel.CheckLocation(tp,LOCATION_MZONE,seq+1) then flag=bit.replace(flag,0x1,seq+1) end
					flag=bit.replace(flag,0x1,seq+2)
					flag=bit.replace(flag,0x1,seq+3)
					flag=bit.replace(flag,0x1,seq+4)
				end
				if seq==1 then
					if not Duel.CheckLocation(tp,LOCATION_MZONE,seq-1) then flag=bit.replace(flag,0x1,seq-1) end
					if not Duel.CheckLocation(tp,LOCATION_MZONE,seq+1) then flag=bit.replace(flag,0x1,seq+1) end
					flag=bit.replace(flag,0x1,seq+2)
					flag=bit.replace(flag,0x1,seq+3)
				end
				if seq==2 then
					flag=bit.replace(flag,0x1,seq-2)
					if not Duel.CheckLocation(tp,LOCATION_MZONE,seq-1) then flag=bit.replace(flag,0x1,seq-1) end
					if not Duel.CheckLocation(tp,LOCATION_MZONE,seq+1) then flag=bit.replace(flag,0x1,seq+1) end
					flag=bit.replace(flag,0x1,seq+2)
				end
				if seq==3 then
					flag=bit.replace(flag,0x1,seq-3)
					flag=bit.replace(flag,0x1,seq-2)
					if not Duel.CheckLocation(tp,LOCATION_MZONE,seq-1) then flag=bit.replace(flag,0x1,seq-1) end
					if not Duel.CheckLocation(tp,LOCATION_MZONE,seq+1) then flag=bit.replace(flag,0x1,seq+1) end
				end	 
				if seq==4 then
					flag=bit.replace(flag,0x1,seq-4)
					flag=bit.replace(flag,0x1,seq-3)
					flag=bit.replace(flag,0x1,seq-2)
					if not Duel.CheckLocation(tp,LOCATION_MZONE,seq-1) then flag=bit.replace(flag,0x1,seq-1) end
				end	 
				flag=bit.bxor(flag,0xff)
				Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP,flag)
			end
		end
	end
	local gn=g:Filter(c1160023.ofilter2_2,nil)	  
	if gn:GetCount()>0 then
		Duel.SendtoGrave(gn,REASON_EFFECT)
		Duel.Recover(tp,gn:GetCount()*500,REASON_EFFECT)
	end
end
--
function c1160023.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetCustomActivityCount(1160023,tp,ACTIVITY_SPSUMMON)==0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,tp,LOCATION_REMOVED)
end
--
function c1160023.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
--
		local e3_1=Effect.CreateEffect(c)
		e3_1:SetType(EFFECT_TYPE_SINGLE)
		e3_1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e3_1:SetValue(LOCATION_HAND)
		e3_1:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e3_1)
--
		local fid=c:GetFieldID()
		c:RegisterFlagEffect(tp,1160023,RESET_PHASE+PHASE_END,0,1,fid)
--
		local e3_2=Effect.CreateEffect(e:GetHandler())
		e3_2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e3_2:SetCode(EVENT_CHAINING)
		e3_2:SetLabel(fid)
		e3_2:SetLabelObject(c)
		e3_2:SetCondition(c1160023.con3_2)
		e3_2:SetOperation(c1160023.op3_2)
		e3_2:SetReset(RESET_PHASE+PHASE_END,2)
		Duel.RegisterEffect(e3_2,tp)
--
	end
end
--
function c1160023.con3_2(e,tp,eg,ep,ev,re,r,rp)
	local fid=e:GetLabel()
	local c=e:GetLabelObject()
	return re:GetHandler():GetControler()~=tp and not c:GetFlagEffectLabel(1160023)==fid
end
function c1160023.op3_2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Recover(tp,200,REASON_EFFECT)
end
--
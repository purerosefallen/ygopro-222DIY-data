--宇宙战争兵器 外壳 折反镭射
function c13257206.initial_effect(c)
	c:EnableReviveLimit()
	--equip limit
	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_SINGLE)
	e11:SetCode(EFFECT_EQUIP_LIMIT)
	e11:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e11:SetValue(c13257206.eqlimit)
	c:RegisterEffect(e11)
	--immune
	local e12=Effect.CreateEffect(c)
	e12:SetType(EFFECT_TYPE_SINGLE)
	e12:SetCode(EFFECT_IMMUNE_EFFECT)
	e12:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e12:SetRange(LOCATION_SZONE)
	e12:SetCondition(c13257206.econ)
	e12:SetValue(c13257206.efilter)
	c:RegisterEffect(e12)
	--atk up
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_EQUIP)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(300)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	e2:SetValue(300)
	c:RegisterEffect(e2)
	--damage
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_SZONE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetOperation(c13257206.regop)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_CHAIN_SOLVED)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCondition(c13257206.damcon)
	e4:SetOperation(c13257206.damop)
	c:RegisterEffect(e4)
	--damage
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCode(EVENT_SUMMON_SUCCESS)
	e5:SetCondition(c13257206.damcon1)
	e5:SetOperation(c13257206.damop)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e6)
	local e7=e5:Clone()
	e7:SetCode(EVENT_SPSUMMON_SUCCESS)
	e7:SetCondition(c13257206.damcon2)
	c:RegisterEffect(e7)
	--Mk-3 Laser
	local e8=Effect.CreateEffect(c)
	e8:SetDescription(aux.Stringid(13257206,0))
	e8:SetType(EFFECT_TYPE_IGNITION)
	e8:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e8:SetRange(LOCATION_MZONE)
	e8:SetCountLimit(1)
	e8:SetCondition(c13257206.econ)
	e8:SetTarget(c13257206.destg)
	e8:SetOperation(c13257206.desop)
	c:RegisterEffect(e8)
	
end
function c13257206.eqlimit(e,c)
	return not (c:GetEquipGroup():FilterCount(Card.IsSetCard,nil,0x3354)>c:GetFlagEffectLabel(13257200)) and not (c:GetEquipGroup():GetSum(Card.GetLevel)>c:GetLevel())
end
function c13257206.econ(e)
	return e:GetHandler():GetEquipTarget()
end
function c13257206.efilter(e,re)
	return e:GetHandlerPlayer()~=re:GetOwnerPlayer()
end
function c13257206.regop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():GetEquipTarget() then
		e:GetHandler():RegisterFlagEffect(13257206,RESET_EVENT+0x1fc0000+RESET_CHAIN,0,1)
	end
end
function c13257206.damcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return e:GetHandler():GetEquipTarget() and ep~=tp and c:GetFlagEffect(13257206)~=0
end
function c13257206.damop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():GetEquipTarget() then
		Duel.Hint(HINT_CARD,0,13257206)
		Duel.Damage(1-tp,e:GetHandler():GetFlagEffectLabel(13257200)*100,REASON_EFFECT)
	end
end
function c13257206.cfilter(c,tp)
	return c:GetSummonPlayer()==tp
end
function c13257206.damcon1(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetEquipTarget() and eg:IsExists(c13257206.cfilter,1,nil,1-tp)
end
function c13257206.damcon2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetEquipTarget() and rp~=tp
end
function c13257206.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(nil,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,nil,tp,0,LOCATION_MZONE,1,1,nil)
	--Reflex Function
	local tc=g:GetFirst()
	local seq=tc:GetSequence()
		if seq>0 then
			local tc1=nil
			local ex=0--if location EXZONE
			local area=0--if location MZONE
			if tc:IsLocation(LOCATION_MZONE) then
				if seq==5 then seq=1
					ex=1
				elseif seq==6 then seq=3
					ex=1
				end
				area=1
			end
			if tc:IsLocation(LOCATION_SZONE) then
				if seq==6 then seq=0
				elseif seq==7 then seq=4
				end
			end
			local lseq=seq-1--get seq at left
			if ex==1 and area==1 then
				tc1=Duel.GetFieldCard(1-tp,LOCATION_MZONE,lseq)
				if tc1 then g:AddCard(tc1)
				end
			end
			if area==1 then
				tc1=Duel.GetFieldCard(1-tp,LOCATION_SZONE,lseq)
				if tc1 then g:AddCard(tc1)
				end
			end
		end
		if seq<4 or seq>4 then
			local tc1=nil
			local ex=0--if location EXZONE
			local area=0--if location MZONE
			if tc:IsLocation(LOCATION_MZONE) then
				if seq==5 then seq=1
					ex=1
				elseif seq==6 then seq=3
					ex=1
				end
				area=1
			end
			if tc:IsLocation(LOCATION_SZONE) then
				if seq==6 then seq=0
				elseif seq==7 then seq=4
				end
			end
			local rseq=seq+1--get seq at right
			if ex==1 and area==1 then
				tc1=Duel.GetFieldCard(1-tp,LOCATION_MZONE,rseq)
				if tc1 then g:AddCard(tc1)
				end
			end
			if area==1 then
				tc1=Duel.GetFieldCard(1-tp,LOCATION_SZONE,rseq)
				if tc1 then g:AddCard(tc1)
				end
			end
		end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c13257206.desop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:GetControler()~=tp then
		local g=Group.CreateGroup()
		local seq=tc:GetSequence()
		if seq>0 then
			local tc1=nil
			local ex=0--if location EXZONE
			local area=0--if location MZONE
			if tc:IsLocation(LOCATION_MZONE) then
				if seq==5 then seq=1
					ex=1
				elseif seq==6 then seq=3
					ex=1
				end
				area=1
			end
			if tc:IsLocation(LOCATION_SZONE) then
				if seq==6 then seq=0
				elseif seq==7 then seq=4
				end
			end
			local lseq=seq-1--get seq at left
			if ex==1 and area==1 then
				tc1=Duel.GetFieldCard(1-tp,LOCATION_MZONE,lseq)
				if tc1 then g:AddCard(tc1)
				end
			end
			if area==1 then
				tc1=Duel.GetFieldCard(1-tp,LOCATION_SZONE,lseq)
				if tc1 then g:AddCard(tc1)
				end
			end
		end
		if seq<4 or seq>4 then
			local tc1=nil
			local ex=0--if location EXZONE
			local area=0--if location MZONE
			if tc:IsLocation(LOCATION_MZONE) then
				if seq==5 then seq=1
					ex=1
				elseif seq==6 then seq=3
					ex=1
				end
				area=1
			end
			if tc:IsLocation(LOCATION_SZONE) then
				if seq==6 then seq=0
				elseif seq==7 then seq=4
				end
			end
			local rseq=seq+1--get seq at right
			if ex==1 and area==1 then
				tc1=Duel.GetFieldCard(1-tp,LOCATION_MZONE,rseq)
				if tc1 then g:AddCard(tc1)
				end
			end
			if area==1 then
				tc1=Duel.GetFieldCard(1-tp,LOCATION_SZONE,rseq)
				if tc1 then g:AddCard(tc1)
				end
			end
		end
		Duel.Destroy(g,REASON_EFFECT)
	end
end

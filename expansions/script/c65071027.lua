--噪声
function c65071027.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(c65071027.activate)
	c:RegisterEffect(e1)
	--remain field
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_REMAIN_FIELD)
	c:RegisterEffect(e3)
end
function c65071027.activate(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():SetTurnCounter(0)
	local ct=Duel.AnnounceNumber(tp,2,3,4,5)
	--destroy
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_SZONE)
	e1:SetLabel(ct)
	e1:SetOperation(c65071027.desop)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,ct)
	e:GetHandler():RegisterEffect(e1)
	e:GetHandler():RegisterFlagEffect(1082946,RESET_PHASE+PHASE_END,0,ct)
	c65071027[e:GetHandler()]=e1
end
function c65071027.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=c:GetTurnCounter()
	ct=ct+1
	c:SetTurnCounter(ct)
	if ct==e:GetLabel() then
		if (ct==4 or ct==5) and Duel.SelectYesNo(tp,aux.Stringid(65071027,1)) then
			local sg=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,LOCATION_MZONE,1,1,nil)
			if sg:GetCount()>0 then
			Duel.HintSelection(sg)
			Duel.SendtoGrave(sg,REASON_EFFECT)
			end
		end
		if Duel.GetLocationCount(1-tp,LOCATION_MZONE,PLAYER_NONE,0)<ct then ct=Duel.GetLocationCount(1-tp,LOCATION_MZONE,PLAYER_NONE,0) end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetRange(LOCATION_SZONE)
		e1:SetCode(EFFECT_DISABLE_FIELD)
		e1:SetOperation(c65071027.disop)
		e1:SetLabel(ct)
		c:RegisterEffect(e1)
		c:ResetFlagEffect(1082946)
	end
end

function c65071027.disop(e,tp)
	local c=Duel.GetLocationCount(1-tp,LOCATION_MZONE,PLAYER_NONE,0)
	if c==0 then return end
	local dis1=Duel.SelectDisableField(tp,1,0,LOCATION_MZONE,0)
	if c>1 and Duel.SelectYesNo(tp,aux.Stringid(65071027,0)) then
		local dis2=Duel.SelectDisableField(tp,1,0,LOCATION_MZONE,dis1)
		dis1=bit.bor(dis1,dis2)
		if c>2 and e:GetLabel()>2 and Duel.SelectYesNo(tp,aux.Stringid(65071027,0)) then
			local dis3=Duel.SelectDisableField(tp,1,0,LOCATION_MZONE,dis1)
			dis1=bit.bor(dis1,dis3)
			if c>3 and e:GetLabel()>3 and Duel.SelectYesNo(tp,aux.Stringid(65071027,0)) then
				local dis4=Duel.SelectDisableField(tp,1,0,LOCATION_MZONE,dis1)
				dis1=bit.bor(dis1,dis4)
				if c>4 and e:GetLabel()>4 and Duel.SelectYesNo(tp,aux.Stringid(65071027,0)) then
					local dis5=Duel.SelectDisableField(tp,1,0,LOCATION_MZONE,dis1)
					dis1=bit.bor(dis1,dis5)
				end
			end
		end
	end
	return dis1
end
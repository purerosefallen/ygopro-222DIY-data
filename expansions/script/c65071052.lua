--美味苏打
function c65071052.initial_effect(c)
	--Control
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON+CATEGORY_CONTROL)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetCountLimit(1,65071052+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c65071052.condition)
	e1:SetTarget(c65071052.target)
	e1:SetOperation(c65071052.activate)
	c:RegisterEffect(e1)
end
function c65071052.condition(e,tp,eg,ep,ev,re,r,rp)
	return tp~=Duel.GetTurnPlayer()
end
function c65071052.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local tg=Duel.GetAttacker()
	if chkc then return chkc==tg end
	if chk==0 then return tg:IsOnField() and tg:IsAbleToRemove() and tg:IsCanBeEffectTarget(e) end
	Duel.SetTargetCard(tg)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,tg,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c65071052.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local c,g=e:GetHandler(),Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if tc:IsRelateToEffect(e) and tc:IsAttackable() and not tc:IsStatus(STATUS_ATTACK_CANCELED) then
		if Duel.Remove(g,POS_FACEUP,REASON_EFFECT)~=0 then
			local rg=Duel.GetOperatedGroup()
			rg:KeepAlive()
			if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
				local tc,fid=rg:GetFirst(),c:GetFieldID()
				while tc do
					tc:RegisterFlagEffect(65071052,RESET_EVENT+0x1fe0000,0,0,fid)
					tc=rg:GetNext()
				end
				local e2=Effect.CreateEffect(c)
				e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
				e2:SetCode(EVENT_PHASE+PHASE_END)
				e2:SetReset(RESET_PHASE+PHASE_END)
				e2:SetCountLimit(1)
				e2:SetOperation(c65071052.endop)
				Duel.RegisterEffect(e2,tp)
				e2:SetLabelObject(rg)
				e2:SetLabel(fid)
			end
		end
	end
end

function c65071052.endop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,65071052)
	local mg=e:GetLabelObject()
	local tg,ft,sg=mg:Filter(c65071052.spfilter,nil,e,tp),Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 or tg:GetCount()<=0 then   
	   mg:DeleteGroup()
	   e:Reset()
	return 
	end
	if ft>=tg:GetCount() then
	   sg=tg:Clone()
	else
	   local ct=math.min(tg:GetCount(),ft)
	   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	   sg=tg:Select(tp,ft,ft,nil)
	end
	Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
end
function c65071052.spfilter(c,e,tp)
	return c:GetFlagEffectLabel(65071052)==e:GetLabel() and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
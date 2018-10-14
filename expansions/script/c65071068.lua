--圣宣
function c65071068.initial_effect(c)
	--Activate(summon)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetTarget(c65071068.target)
	e1:SetOperation(c65071068.activate)
	c:RegisterEffect(e1)
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DESTROY+CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_ACTIVATE)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetTarget(c65071068.target2)
	e3:SetOperation(c65071068.activate2)
	c:RegisterEffect(e3)
end
function c65071068.filter(c,tp,ep)
	return c:IsLocation(LOCATION_MZONE) and c:IsFaceup() and (c:GetAttack()<=1000 or c:GetDefense()<=1000)
end
function c65071068.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=eg:GetFirst()
	if chk==0 then return c65071068.filter(tc,tp,ep) end
	Duel.SetTargetCard(eg)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,tc,1,0,0)
end
function c65071068.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	local seq=tc:GetSequence()
	if tc:IsControler(1-tp) then seq=seq+16 end
	if tc and tc:IsRelateToEffect(e) and tc:IsFaceup() and (tc:GetAttack()<=1000 or tc:GetDefense()<=1000) then
		if Duel.Destroy(tc,REASON_EFFECT)~=0 then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetCode(EFFECT_DISABLE_FIELD)
			e1:SetLabel(seq)
			e1:SetOperation(c65071068.disop)
			e1:SetReset(RESET_PHASE+PHASE_END,2)
			Duel.RegisterEffect(e1,tp)
		end
	end
end
function c65071068.disop(e,tp)
	return e:GetLabel()
end
function c65071068.filter2(c,tp)
	return c:IsLocation(LOCATION_MZONE) and c:IsFaceup() and (c:GetAttack()<=1000 or c:GetDefense()<=1000)
end
function c65071068.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c65071068.filter2,1,nil,tp) end
	local g=eg:Filter(c65071068.filter2,nil,tp)
	Duel.SetTargetCard(eg)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c65071068.filter3(c,e,tp)
	return c:IsFaceup() and (c:GetAttack()<=1000 or c:GetDefense()<=1000)
		and c:IsRelateToEffect(e) and c:IsLocation(LOCATION_MZONE)
end
function c65071068.activate2(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(c65071068.filter3,nil,e,tp)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		while tc do
		local seq=tc:GetSequence()
		if tc:IsControler(1-tp) then seq=seq+16 end
			if Duel.Destroy(g,REASON_EFFECT)~=0 then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetCode(EFFECT_DISABLE_FIELD)
			e1:SetLabel(seq)
			e1:SetOperation(c65071068.disop)
			e1:SetReset(RESET_PHASE+PHASE_END,2)
			Duel.RegisterEffect(e1,tp)
			end
		end
	end
end

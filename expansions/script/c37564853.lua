--3L·Apparition Lover
local m=37564853
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c37564765") end,function() require("script/c37564765") end)
function cm.initial_effect(c)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetRange(LOCATION_HAND)
	e3:SetCountLimit(1,m)
	e3:SetCondition(function(e,tp,eg,ep,ev,re,r,rp) return ep~=tp end)
	e3:SetTarget(cm.sptg)
	e3:SetOperation(cm.spop)
	c:RegisterEffect(e3)
end
function cm.effect_operation_3L(c,ctlm)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0x3c0)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCountLimit(ctlm,1)
	e2:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
		return not Duel.CheckEvent(EVENT_CHAINING)
	end)
	e2:SetCost(Senya.ForbiddenCost(Senya.DescriptionCost()))
	e2:SetTarget(cm.CopySpellNormalTarget)
	e2:SetOperation(Senya.CopyOperation)
	e2:SetReset(0x1fe1000)
	c:RegisterEffect(e2,true)
	local e1=e2:Clone()
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(aux.TRUE)
	c:RegisterEffect(e1,true)
	return e1,e2
end
function cm.GetHandEffect(c)
	Senya.urara_cache=Senya.urara_cache or {}
	local code=c:GetOriginalCode()
	if Senya.urara_cache[code] then return Senya.urara_cache[code] end
	local eset={}
	local temp=Card.RegisterEffect
	Card.RegisterEffect=function(tc,e,f)
		if (e:GetRange()&LOCATION_HAND)>0 and e:IsHasType(0x7e0) then
			table.insert(eset,e:Clone())
		end
		return temp(tc,e,f)
	end
	Senya.IgnoreActionCheck(Duel.CreateToken,c:GetControler(),code)
	Card.RegisterEffect=temp
	Senya.urara_cache[code]=eset
	return eset
end
function cm.CheckHandEffect(c,sec,e,tp,eg,ep,ev,re,r,rp)
	local eset=cm.GetHandEffect(c)
	if #eset==0 then return false end
	local ee,teg,tep,tev,tre,tr,trp
	for _,te in ipairs(eset) do
		local tres=false
		local code=te:GetCode()
		if code~=EVENT_CHAINING and code~=EVENT_FREE_CHAIN then
			tres,teg,tep,tev,tre,tr,trp=Duel.CheckEvent(code,true)
		elseif sec or code==EVENT_FREE_CHAIN then
			tres=true
			teg,tep,tev,tre,tr,trp=eg,ep,ev,re,r,rp
		end
		if tres then
			local con=te:GetCondition()
			local tg=te:GetTarget()
			if Senya.ProtectedRun(con,e,tp,teg,tep,tev,tre,tr,trp) and Senya.ProtectedRun(tg,e,tp,teg,tep,tev,tre,tr,trp,0) then
				ee=te
				break
			end
		end
	end
	if ee then
		return true,ee,teg,tep,tev,tre,tr,trp
	else
		return false
	end
end
function cm.CopySpellNormalFilter(c,sec,e,tp,eg,ep,ev,re,r,rp)
	local te=cm.GetHandEffect(c)
	return c:IsType(TYPE_TUNER) and c:IsAttack(0) and c:IsDefense(1800) and c:IsLevel(3)
		and c:IsAbleToGraveAsCost() and cm.CheckHandEffect(c,sec,e,tp,eg,ep,ev,re,r,rp)
end
function cm.CopySpellNormalTarget(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		local te=e:GetLabelObject()
		local tg=te:GetTarget()
		return te:IsHasProperty(EFFECT_FLAG_CARD_TARGET) and Senya.ProtectedRun(tg,e,tp,eg,ep,ev,re,r,rp,0,chkc)
	end
	local og=Duel.GetFieldGroup(tp,LOCATION_DECK,0)
	local sec=(e:GetCode()==EVENT_CHAINING)
	if chk==0 then
		if e:GetLabel()==0 then return false end
		e:SetLabel(0)
		return og:IsExists(cm.CopySpellNormalFilter,1,nil,sec,e,tp,eg,ep,ev,re,r,rp)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=og:FilterSelect(tp,cm.CopySpellNormalFilter,1,1,nil,sec,e,tp,eg,ep,ev,re,r,rp)
	local _,te,ceg,cep,cev,cre,cr,crp=cm.CheckHandEffect(g:GetFirst(),sec,e,tp,eg,ep,ev,re,r,rp)
	Duel.SendtoGrave(g,REASON_COST)
	e:SetCategory(te:GetCategory())
	e:SetProperty(te:GetProperty())
	e:SetLabel(te:GetLabel())
	local tg=te:GetTarget()
	Senya.ProtectedRun(tg,e,tp,ceg,cep,cev,cre,cr,crp,1)
	te:SetLabelObject(e:GetLabelObject())
	e:SetLabelObject(te)
	local ex=Effect.GlobalEffect()
	ex:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	ex:SetCode(EVENT_CHAIN_END)
	ex:SetLabelObject(e)
	ex:SetOperation(function(e)
		e:GetLabelObject():SetLabel(0)
		ex:Reset()
	end)
	Duel.RegisterEffect(ex,tp)
end
function cm.flimit(gc)
	return function(tp,g,fc)
		return not g:IsExists(Senya.NOT(Senya.check_fusion_set_3L),1,gc)
	end
end
function cm.fcheck(c,m,gc,chkf)
	aux.FCheckAdditional=cm.flimit(gc)
	local res=c:CheckFusionMaterial(m,gc,chkf)
	aux.FCheckAdditional=nil
	return res
end

function cm.fselect(tp,tc,mg,gc,chkf)
	aux.FCheckAdditional=cm.flimit(gc)
	local g=Duel.SelectFusionMaterial(tp,tc,mg,gc,chkf)
	aux.FCheckAdditional=nil
	return g
end
function cm.spfilter2(c,e,tp,m,f,gc,chkf)
	return c:IsType(TYPE_FUSION) and (not f or f(c)) and Senya.check_set_3L(c)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and cm.fcheck(c,m,gc,chkf)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		if not c:IsLocation(LOCATION_HAND) then return false end
		local chkf=tp
		local mg1=Senya.GetFusionMaterial(tp,LOCATION_HAND,nil,Senya.check_set_3L,c)
		local res=Duel.IsExistingMatchingCard(cm.spfilter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,c,chkf)
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg2=fgroup(ce,e,tp):Filter(Senya.check_set_3L,nil)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(cm.spfilter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg2,mf,c,chkf)
			end
		end
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local chkf=tp
	local mg1=Senya.GetFusionMaterial(tp,LOCATION_HAND,nil,Senya.check_set_3L,c,e)
	local sg1=Duel.GetMatchingGroup(cm.spfilter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,c,chkf)
	local mg2=nil
	local sg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg2=fgroup(ce,e,tp):Filter(Senya.check_set_3L,nil)
		local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(cm.spfilter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg2,mf,c,chkf)
	end
	if #sg1>0 or (sg2~=nil and #sg2>0) then
		local sg=sg1:Clone()
		if sg2 then sg:Merge(sg2) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=sg:Select(tp,1,1,nil)
		local tc=tg:GetFirst()
		if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then
			local mat1=cm.fselect(tp,tc,mg1,c,chkf)
			tc:SetMaterial(mat1)
			Duel.SendtoGrave(mat1,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			Duel.BreakEffect()
			Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
		else
			local mat2=cm.fselect(tp,tc,mg2,c,chkf)
			local fop=ce:GetOperation()
			fop(ce,e,tp,tc,mat2)
		end
		tc:CompleteProcedure()
	end
end
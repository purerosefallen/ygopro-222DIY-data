--龙棋兵团翼状阵型
if not pcall(function() require("expansions/script/c18006001") end) then require("script/c18006001") end
local m=18006012
local cm=_G["c"..m]
cm.rssetcode="DragonChessCorps"
function cm.initial_effect(c)
	local e1=rsdcc.Activate(c,m,nil,cm.op,cm.tg2)
	--extra summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,0)
	e2:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
	e2:SetTarget(aux.TargetBoolFunction(rscf.CheckSetCard,"DragonChessCorps"))
	c:RegisterEffect(e2)
	--disable
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_DISABLE)
	e4:SetRange(LOCATION_SZONE)
	e4:SetTargetRange(LOCATION_SZONE,LOCATION_SZONE)
	e4:SetTarget(rsdcc.tg2)
	e4:SetLabel(TYPE_TRAP)
	c:RegisterEffect(e4)
end
function cm.tg2(c,e,tp)
	local seq=c:GetSequence()
	return ((seq<5 and seq>0 and Duel.CheckLocation(tp,LOCATION_MZONE,seq-1)) or (seq>-1 and seq<4 and Duel.CheckLocation(tp,LOCATION_MZONE,seq+1))) and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp)
end
function cm.spfilter(c,e,tp)
	return rsdcc.IsSet(c) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.op(e,tp)
	local tc=rscf.GetTargetCard(aux.FilterBoolFunction(Card.IsControler,tp))
	if not tc then return end
	local seq=tc:GetSequence()
	if seq>4 then return end
	local seq1,zone=0,0
	if seq>-1 and seq<4 then zone=zone|2^(seq+1) end
	if seq>0 and seq<5 then zone=zone|2^(seq-1) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp):GetFirst()
	if tc then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP,zone)
	end
end